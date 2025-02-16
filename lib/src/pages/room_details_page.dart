import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/general_helper.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../providers/room/room_provider.dart';
import '../models/facility.dart';
import '../models/room.dart' as r;
import '../widgets/room_price_widget.dart';
import '../widgets/view_widget.dart';

class RoomDetailsPage extends ConsumerStatefulWidget {
  final Facility facility;

  const RoomDetailsPage({Key? key, required this.facility}) : super(key: key);

  @override
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends ConsumerState<RoomDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  Timer? imageTimer;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    pageController = PageController(viewportFraction: 1);

    imageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageController.hasClients) {
        if (pageController.page ==
            widget.facility.rooms.first.media.length - 1) {
          pageController.jumpToPage(0);
        } else {
          pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      }
    });

    Future.microtask(() async {
      final value = await ref
          .read(roomProvider.notifier)
          .fetch(roomId: widget.facility.rooms.first.id);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    imageTimer?.cancel();
    super.dispose();
  }

  void _showMapDialog(Facility facility) {
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
              markers: {
                Marker(
                  markerId: MarkerId(facility.id.toString()),
                  position: LatLng(
                    facility.latitude ?? 0.0,
                    facility.longitude ?? 0.0,
                  ),
                  infoWindow: InfoWindow(title: facility.name),
                ),
              },
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
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: widget.facility.name,
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: ViewWidget<r.Room>(
        meta: roomState.meta,
        data: roomState.data,
        refresh: () async => await ref
            .read(roomProvider.notifier)
            .fetch(roomId: widget.facility.rooms.first.id),
        forceShowLoaded: roomState.data != null,
        onLoaded: (room) {
          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: room.media.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: room.media[index].original_url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.map, color: Colors.white),
                  onPressed: () => _showMapDialog(widget.facility),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.55,
                minChildSize: 0.55,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room.name,
                                style: TextStyle(
                                  color: CustomTheme.primaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TabBar(
                                controller: tabController,
                                labelColor: CustomTheme.primaryColor,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: CustomTheme.primaryColor,
                                tabs: [
                                  Tab(
                                    text: trans().description,
                                  ),
                                  Tab(
                                    text: trans().amenity,
                                  ),
                                  Tab(
                                    text: trans().price,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 300,
                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    // Tab 1: Description
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          room.desc,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    // Tab 2: Amenities
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: room.amenities.isNotEmpty
                                              ? room.amenities.map((a) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.checkDouble,
                                                    size: 18,
                                                    color: CustomTheme.primaryColor,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    a.name,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList()
                                              : [
                                            Text(
                                              "${trans().amenity}: ${trans().noAmenities}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Tab 3: Prices
                                    Expanded(
                                      child: ListView(
                                        children: room.roomPrices.isNotEmpty
                                            ? room.roomPrices.map((price) {
                                          return RoomPriceWidget(price: price);
                                        }).toList()
                                            : [
                                          Text(
                                            "${trans().price}: ${trans().priceNotAvailable}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            ],
                          )));

                },
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Button(
                  width: double.infinity,
                  disable: false,
                  onPressed: () async {
                    Navigator.pushNamed(
                      context,
                      Routes.priceAndCalendar,
                      arguments: room.id,
                    );
                  },
                  title: trans().showAvailableDays,
                  icon: Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Colors.white,
                  ),
                //  iconAfterText: true,
                ),
              ),
            ],
          );
        },
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () => Center(
          child: Text(trans().no_data),
        ),
        showError: true,
        showEmpty: true,
      ),
    );
  }
}
