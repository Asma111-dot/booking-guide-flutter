import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../models/facility.dart' as f;
import '../providers/facility/facility_provider.dart';
import '../sheetes/facility_search_delegate.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/sizes.dart';
import '../utils/theme.dart';
import '../widgets/view_widget.dart';

class MapPage extends ConsumerStatefulWidget {
  final int facilityTypeId;

  const MapPage({super.key, required this.facilityTypeId});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  GoogleMapController? mapController;
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  int? selectedMarkerId;
  List<f.Facility> _lastFacilities = const [];

  getProvider() => facilitiesProvider(FacilityTarget.maps);

  @override
  void initState() {
    super.initState();


    Future.microtask(() {
      ref.read(getProvider().notifier).fetch(facilityTypeId: widget.facilityTypeId);
    });
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void moveToLocation(List<f.Facility> data) {
    if (data.isNotEmpty && mapController != null) {
      double avgLat =
          data.map((f) => f.latitude ?? 0.0).reduce((a, b) => a + b) /
              data.length;
      double avgLng =
          data.map((f) => f.longitude ?? 0.0).reduce((a, b) => a + b) /
              data.length;
      mapController!
          .animateCamera(CameraUpdate.newLatLng(LatLng(avgLat, avgLng)));
    }
  }

  double hueFromColor(Color color) {
    return HSVColor.fromColor(color).hue;
  }

  double darkerHueFromColor(Color color) {
    final hsv = HSVColor.fromColor(color);
    final darker = hsv.withValue((hsv.value * 0.1).clamp(0.0, 1.0));
    return darker.hue;
  }

  Widget _buildInfoCard(BuildContext context, f.Facility facility) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: S.h(140),
      width: S.w(140),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              facility.logo ?? '',
              height: S.h(80),
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                appIcon,
                height: S.h(80),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: S.h(6), horizontal: S.w(10)),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                facility.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: TFont.s12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFacilitySearch() async {
    if (_lastFacilities.isEmpty) return;

    final result = await showSearch<f.Facility?>(
      context: context,
      delegate: FacilitySearchDelegate(_lastFacilities),
    );

    if (result == null) return;

    _flyToFacility(result);
  }

  void _flyToFacility(f.Facility facility) async {
    final lat = facility.latitude ?? 0.0;
    final lng = facility.longitude ?? 0.0;

    setState(() => selectedMarkerId = facility.id); // ← يغير لون الماركر المحدد

    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 16),
      ),
    );

    _customInfoWindowController.hideInfoWindow!(); // تنظيف أي نافذة سابقة

    _customInfoWindowController.addInfoWindow!(
      GestureDetector(
        onTap: () => Navigator.pushNamed(context, Routes.roomDetails, arguments: facility),
        child: _buildInfoCard(context, facility), // ← نفس الكرت
      ),
      LatLng(lat, lng),
    );
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(getProvider());

    // final double normalHue = hueFromColor(CustomTheme.whiteColor);
    // final double selectedHue = darkerHueFromColor(CustomTheme.primaryColor);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double normalHue = isDark
        ? BitmapDescriptor.hueAzure
        : BitmapDescriptor.hueAzure;

    final double selectedHue = isDark
        ? BitmapDescriptor.hueViolet
        : BitmapDescriptor.hueViolet;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          trans().map,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: CustomTheme.color2,
            fontWeight: FontWeight.bold,
          ),
        ),
          elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: CustomTheme.color3),
        actions: [
          IconButton(
            icon: const Icon(searchIcon),
            tooltip: 'بحث في المنشآت',
            onPressed: _openFacilitySearch,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Insets.m16),
            child: Text(
              trans().mapHint,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: ViewWidget<List<f.Facility>>(
              meta: facilitiesState.meta,
              data: facilitiesState.data,
              refresh: () async {
                await ref
                    .read(getProvider().notifier)
                    .fetch(facilityTypeId: widget.facilityTypeId);
                setState(() {});
              },
              forceShowLoaded: facilitiesState.data != null,
              onLoaded: (data) {
                _lastFacilities = data;
                final theme = Theme.of(context);
                final colorScheme = theme.colorScheme;
                // final isDark = theme.brightness == Brightness.dark;
                final Set<Marker> markers = data.map((facility) {
                  final bool isSelected = selectedMarkerId == facility.id;
                  print('${facility.name} => lat: ${facility.latitude}, lng: ${facility.longitude}');
                  return Marker(
                    markerId: MarkerId(facility.id.toString()),
                    position: LatLng(
                        facility.latitude ?? 0.0, facility.longitude ?? 0.0),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      isSelected ? selectedHue : normalHue,
                    ),
                    // zIndex: isSelected ? 1000 : 0, // ← هنا
                    onTap: () {
                      setState(() => selectedMarkerId = facility.id);

                      _customInfoWindowController.hideInfoWindow!(); // تنظيف
                      _customInfoWindowController.addInfoWindow!(
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, Routes.roomDetails, arguments: facility),
                          child: _buildInfoCard(context, facility), // ← نفس الكرت
                        ),
                        LatLng(facility.latitude ?? 0.0, facility.longitude ?? 0.0),
                      );
                    },
                  );
                }).toSet();

                if (data.isNotEmpty) {
                  moveToLocation(data);
                }

                return Stack(
                  children: [
                    GoogleMap(
                      // myLocationEnabled: true,
                      // myLocationButtonEnabled: true,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(15.3520, 44.2075),
                        zoom: 11,
                      ),
                      onMapCreated: (controller) {
                        mapController = controller;
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                      markers: markers,
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                        setState(() => selectedMarkerId = null);
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                    ),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      height: S.h(140),
                      width: S.w(140),
                      offset: S.r(40),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

