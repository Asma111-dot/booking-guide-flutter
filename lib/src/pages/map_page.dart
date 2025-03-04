import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../models/facility.dart' as f;
import '../providers/facility/facility_provider.dart';
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

  getProvider() => facilitiesProvider(FacilityTarget.maps);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getProvider().notifier).fetch(facilityTypeId: widget.facilityId);
    });
  }

  void moveToLocation(List<f.Facility> data) {
    if (data.isNotEmpty && mapController != null) {
      double avgLat = data.map((f) => f.latitude ?? 0.0).reduce((a, b) => a + b) / data.length;
      double avgLng = data.map((f) => f.longitude ?? 0.0).reduce((a, b) => a + b) / data.length;
      mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(avgLat, avgLng)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(getProvider());

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
              'اطلع على جميع المنشآت المتاحة على الخريطة.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ViewWidget<List<f.Facility>>(
              meta: facilitiesState.meta,
              data: facilitiesState.data,
              refresh: () async {
                await
                ref.read(getProvider().notifier).fetch(facilityTypeId: widget.facilityId);
                setState(() {});
              },
              forceShowLoaded: facilitiesState.data != null,
              onLoaded: (data) {
                print("عدد المنشآت: ${data.length}");
                data.forEach((facility) {
                  print("منشأة: ${facility.name}, إحداثيات: (${facility.latitude}, ${facility.longitude})");
                });

                final Set<Marker> markers = data.map((facility) {
                  return Marker(
                    markerId: MarkerId(facility.id.toString()),
                    position: LatLng(facility.latitude ?? 0.0, facility.longitude ?? 0.0),
                    infoWindow: InfoWindow(
                      title: facility.name,
                      snippet: facility.address,
                    ),
                  );
                }).toSet();

                if (data.isNotEmpty) {
                  moveToLocation(data);
                }

                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(15.3520, 44.2075),
                    zoom: 10,
                  ),
                  markers: markers,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                );
              },
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onEmpty: () => const Center(child: Text('لا توجد بيانات متاحة حالياً.')),
              showError: true,
              showEmpty: true,
            ),
          ),
        ],
      ),
    );
  }
}
