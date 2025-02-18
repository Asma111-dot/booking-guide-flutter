import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/facility.dart';
import '../providers/facility/facility_provider.dart';
import '../widgets/view_widget.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    // تحميل البيانات عند بدء الصفحة
    Future.microtask(() {
      ref.read(facilitiesProvider.notifier).fetch(facilityTypeId: 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('خريطة المنشآت'),
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
            child: ViewWidget<List<Facility>>(
              meta: facilitiesState.meta,
              data: facilitiesState.data,
              refresh: () async {
                await ref.read(facilitiesProvider.notifier).fetch(facilityTypeId: 2);
                setState(() {});  // تحديث الحالة لإعادة تحميل الماركرات
              },
              forceShowLoaded: facilitiesState.data != null,
              onLoaded: (data) {
                print("عدد المنشآت: ${data.length}");
                // التأكد من إحداثيات كل منشأة
                data.forEach((facility) {
                  print("منشأة: ${facility.name}, إحداثيات: (${facility.latitude}, ${facility.longitude})");
                });

                // تأكد من أن البيانات تحتوي على إحداثيات صحيحة
                final Set<Marker> markers = data.map((facility) {
                  final marker = Marker(
                    markerId: MarkerId(facility.id.toString()),
                    position: LatLng(
                      facility.latitude ?? 0.0,
                      facility.longitude ?? 0.0,
                    ),
                    infoWindow: InfoWindow(
                      title: facility.name,
                      snippet: facility.address,
                    ),
                  );
                  print("Marker ID: ${facility.id}, Position: ${marker.position}");
                  return marker;
                }).toSet();

                // حساب إحداثيات الكاميرا لتناسب الماركرات
                // double minLat = double.infinity;
                // double maxLat = -double.infinity;
                // double minLng = double.infinity;
                // double maxLng = -double.infinity;
                //
                // for (var facility in data) {
                //   minLat = facility.latitude! < minLat ? facility.latitude! : minLat;
                //   maxLat = facility.latitude! > maxLat ? facility.latitude! : maxLat;
                //   minLng = facility.longitude! < minLng ? facility.longitude! : minLng;
                //   maxLng = facility.longitude! > maxLng ? facility.longitude! : maxLng;
                // }
                //
                // // تعيين الكاميرا لتناسب إحداثيات الماركرات
                // LatLngBounds bounds = LatLngBounds(
                //   southwest: LatLng(minLat, minLng),
                //   northeast: LatLng(maxLat, maxLng),
                // );

                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(15.382585, 47.060712),
                    // target: LatLng(
                    //     (minLat + maxLat) / 2, (minLng + maxLng) / 2),
                    zoom: 10,
                  ),
                  markers: markers, // تأكد من أن الماركرات يتم تمريرها هنا
                  onMapCreated: (controller) {
                    mapController = controller;
                    // ضبط الكاميرا لتناسب الماركرات
                   // mapController.moveCamera(CameraUpdate.newLatLngBounds(bounds, 50));
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
