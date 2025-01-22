import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/facility.dart';

class MapDialog extends StatelessWidget {
  final Facility facility;
  final List<Facility> facilities;

  const MapDialog({
    Key? key,
    required this.facility,
    required this.facilities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 500,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              facility.latitude ?? 15.5520,
              facility.longitude ?? 48.5164,
            ),
            zoom: 12,
          ),
          markers: facilities.map((facility) {
            return Marker(
              markerId: MarkerId(facility.id.toString()),
              position: LatLng(
                facility.latitude ?? 0.0,
                facility.longitude ?? 0.0,
              ),
              infoWindow: InfoWindow(title: facility.name),
            );
          }).toSet(),
        ),
      ),
    );
  }
}
