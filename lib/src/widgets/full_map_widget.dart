import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import 'custom_app_bar.dart';

class FullMapWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? name;

  const FullMapWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.name,
  });

  @override
  State<FullMapWidget> createState() => _FullMapWidgetState();
}

class _FullMapWidgetState extends State<FullMapWidget> {
  late GoogleMapController _mapController;
  late LatLng _initialLatLng;
  MapType _mapType = MapType.normal;

  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    final lat = widget.latitude ?? 15.5520;
    final lng = widget.longitude ?? 48.5164;
    _initialLatLng = LatLng(lat, lng);
  }

  void _goToInitialLocation() {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_initialLatLng, 14),
    );
  }

  void _toggleMapType() {
    setState(() {
      _mapType = _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.name ?? "الموقع";

    return Scaffold(
      appBar: CustomAppBar(
        appTitle: title,
        icon: arrowBackIcon,
      ),
      body: GoogleMap(
        mapType: _mapType,
        initialCameraPosition: CameraPosition(
          target: _initialLatLng,
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("location_marker"),
            position: _initialLatLng,
            infoWindow: InfoWindow(title: title),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _isSelected ? BitmapDescriptor.hueViolet : BitmapDescriptor.hueAzure,
            ),
            onTap: () {
              setState(() {
                _isSelected = !_isSelected;
              });
            },
          ),
        },
        onMapCreated: (controller) {
          _mapController = controller;
        },
        compassEnabled: true,
        zoomControlsEnabled: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "centerBtn",
            onPressed: _goToInitialLocation,
            child: Icon(myLocationIcon),
            tooltip: "الرجوع للموقع",
          ),
          Gaps.h12,
          FloatingActionButton(
            heroTag: "mapTypeBtn",
            onPressed: _toggleMapType,
            child: Icon(layerIcon),
            tooltip: "تغيير نوع الخريطة",
          ),
        ],
      ),
    );
  }
}
