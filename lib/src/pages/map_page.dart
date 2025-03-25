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
  final int facilityId;

  const MapPage({Key? key, required this.facilityId}) : super(key: key);

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
      ref.read(getProvider().notifier).fetch(facilityTypeId: widget.facilityId);
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

    final double normalHue = hueFromColor(CustomTheme.placeholderColor);
    final double selectedHue = darkerHueFromColor(CustomTheme.primaryColor);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          trans().map,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: CustomTheme.primaryColor,
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
                    .fetch(facilityTypeId: widget.facilityId);
                setState(() {});
              },
              forceShowLoaded: facilitiesState.data != null,
              onLoaded: (data) {
                final Set<Marker> markers = data.map((facility) {
                  final bool isSelected = selectedMarkerId == facility.id;
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
                          child: Container(
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // ✅ هذا مهم جداً
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    facility.logo ?? '',
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      logoCoverImage,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  color: CustomTheme.primaryColor,
                                  child: Text(
                                    facility.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        LatLng(facility.latitude ?? 0.0,
                            facility.longitude ?? 0.0),
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
                        zoom: 15,
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
