import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../models/facility.dart' as f;
import '../providers/facility/facility_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
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
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  int? selectedMarkerId;

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
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                    onTap: () {
                      setState(() {
                        selectedMarkerId = facility.id;
                      });

                      _customInfoWindowController.addInfoWindow!(
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.roomDetails,
                              arguments: facility,
                            );
                          },
                          child: SizedBox(
                            height: 140,
                            width: 250,
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
                                    height: 80,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      appIcon,
                                      height: 80,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
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
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(15.3520, 44.2075),
                        zoom: 12,
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
                      height: 140,
                      width: 140,
                      offset: 40,
                    ),
                  ],
                );
              },
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onEmpty: () =>  Center(
                child: Text(trans().no_data),
              ),
              showError: true,
              showEmpty: true,
            ),
          ),
        ],
      ),
    );
  }
}
