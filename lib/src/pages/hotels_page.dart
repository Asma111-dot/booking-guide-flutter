import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/general_helper.dart';
import '../providers/facility/facility_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_widget.dart';
import '../models/facility.dart';
import 'hotel_details_page.dart';

class HotelsPage extends ConsumerStatefulWidget {
  const HotelsPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HotelsPageState();
}

class _HotelsPageState extends ConsumerState<HotelsPage> {
  late GoogleMapController mapController;
  LatLng? _selectedLocation;

  void _showMapDialog(Facility facility, List<Facility> facilities) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
              onMapCreated: (controller) {
                mapController = controller;
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(facilitiesProvider.notifier).fetch(facilityTypeId: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilitiesProvider);

    return Scaffold(
      appBar: CustomAppBar(
        appTitle: trans().hotel,
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: ViewWidget<List<Facility>>(
        meta: facilitiesState.meta,
        data: facilitiesState.data,
        onLoaded: (data) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final facility = data[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HotelDetailsPage(facility: facility),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  Image hotel
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child:
                            facility.logo != null && facility.logo!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: facility.logo!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      hotelImage,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset(
                                    hotelImage,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Name hotel
                                Text(
                                  facility.name,
                                  style: const TextStyle(
                                    color: CustomTheme.primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    // price
                                    Text(
                                      "200",
                                      //  "\$${facility.price}/Night",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: CustomTheme.tertiaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      FontAwesomeIcons.dollarSign,
                                      size: 15,
                                      color: CustomTheme.primaryColor,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _showMapDialog(facility, data);
                                      },
                                      child: const Icon(
                                        Icons.location_on_outlined,
                                        color: CustomTheme.primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      facility.address ?? '${trans().address}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                // Reviews
                                Row(
                                  children: [
                                    Text(
                                      "4.9",
                                      //  "${facility.rating ?? 0.0} (${facility.reviewsCount ?? 0} Reviews)",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () =>  Center(
          child: Text(trans().no_data),
        ),
        showError: true,
        showEmpty: true,
      ),
    );
  }
}
