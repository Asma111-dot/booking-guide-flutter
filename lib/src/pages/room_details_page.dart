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
import '../providers/room/room_provider.dart';
import '../models/facility.dart';
import '../models/room.dart' as r;
import '../widgets/room_price_widget.dart';
import '../widgets/view_widget.dart';
import 'image_gallery_page.dart';

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
    Future.microtask(() async {
      final value = await ref
          .read(roomProvider.notifier)
          .fetch(roomId: widget.facility.rooms.first.id);
    });
    tabController = TabController(length: 3, vsync: this);
    pageController = PageController(viewportFraction: 1);
    pageController.addListener(() {
      setState(() {});
    });
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
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    imageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
                  height: 400,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: room.media.length,
                    itemBuilder: (context, index) {
                      final imageUrl = room.media[index].original_url;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageGalleryPage(
                                imageUrls: room.media
                                    .map((m) => m.original_url)
                                    .toList(),
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          tag: imageUrl,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
              top: 20,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: CustomTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon:
                        const Icon(Icons.arrow_back_ios, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: CustomTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white70),
                    onPressed: () async {
                      // await Share.share(textToShare);  // Share the passed text
                    },
                  ),
                ),
              ),
              Positioned(
                top: 200,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1 * 255),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "${pageController.positions.isNotEmpty ? (pageController.page?.toInt() ?? 0) + 1 : 1}/${room.media.length}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.65,
                minChildSize: 0.65,
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
                            color: Colors.black.withValues(alpha: 0.1 * 255),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                          // controller: scrollController,
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
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: CustomTheme.tertiaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                widget.facility.address?.toString() ??
                                    'عنوان غير متوفر',
                                style: TextStyle(
                                  color: CustomTheme.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 150,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  widget.facility.latitude ?? 15.5520,
                                  widget.facility.longitude ?? 48.5164,
                                ),
                                zoom: 12,
                              ),
                              markers: {
                                Marker(
                                  markerId:
                                      MarkerId(widget.facility.id.toString()),
                                  position: LatLng(
                                    widget.facility.latitude ?? 0.0,
                                    widget.facility.longitude ?? 0.0,
                                  ),
                                  infoWindow:
                                      InfoWindow(title: widget.facility.name),
                                ),
                              },
                              onMapCreated: (controller) {
                                mapController = controller;
                              },
                            ),
                          ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: room.amenities.isNotEmpty
                                          ? room.amenities.map((a) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      FontAwesomeIcons
                                                          .checkDouble,
                                                      size: 18,
                                                      color: CustomTheme
                                                          .primaryColor,
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
                                            return RoomPriceWidget(
                                                price: price);
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
