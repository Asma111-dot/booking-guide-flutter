import 'package:booking_guide/src/utils/assets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/general_helper.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_widget.dart';
import '../providers/room/room_provider.dart';
import '../models/room.dart' as r;
import '../models/facility.dart';

class HotelDetailsPage extends ConsumerStatefulWidget {
  final Facility facility;

  const HotelDetailsPage({Key? key, required this.facility}) : super(key: key);

  @override
  _HotelDetailsPageState createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends ConsumerState<HotelDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(roomProvider.notifier).fetch(facilityId: widget.facility.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomProvider);
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: CustomAppBar(
        appTitle: widget.facility.name,
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: ViewWidget<r.Room>(
        meta: roomState.meta,
        data: roomState.data,
        refresh: () async => await ref
            .read(roomProvider.notifier)
            .fetch(facilityId: widget.facility.id),
        forceShowLoaded: roomState.data != null,
        onLoaded: (room) {
          return RefreshIndicator(
            onRefresh: () async => await ref
                .read(roomProvider.notifier)
                .fetch(facilityId: widget.facility.id),
            child: SingleChildScrollView(
              ///
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(15),
                  //   child: Image.asset(
                  //     chaletImage,
                  //     width: double.infinity,
                  //     height: 200,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26.withOpacity(0.15),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        room.media.isNotEmpty
                            ? GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: room.media.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            // print("Media is: ${room.media[index].original_url}");
                            return CachedNetworkImage(
                              imageUrl: room.media[index].original_url,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            );
                          },
                        )
                            : Text('لا توجد وسائط متاحة'),
                        SizedBox(height: 16),
                        Text(
                          room.name,
                          style: TextStyle(
                            color: CustomTheme.primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${trans().capacity}: ${room.capacity}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${trans().status}: ${room.status}",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16,
                          ),
                        ),
                        // Text(
                        //   "${trans().status}: ${room.amenity}",
                        //   style: TextStyle(
                        //     color: Colors.blueGrey,
                        //     fontSize: 16,
                        //   ),
                        // ),
                        // SizedBox(height: 16),
                        TabBar(
                          controller: tabController,
                          labelColor: CustomTheme.primaryColor,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: CustomTheme.primaryColor,
                          tabs: [
                            Tab(text: 'الوصف'),
                            Tab(text: 'وسائل الراحة'),
                            Tab(text: 'السعر'),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                          child: TabBarView(
                            controller: tabController,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    room.desc,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Builder(
                                  builder: (context) {
                                    //  print("Amenities in UI: ${room.amenity.map((a) => a.name).toList()}");

                                    return Text(
                                      room.amenity.isNotEmpty
                                          ? "${trans().amenity}: ${room.amenity.map((a) => a.name).join(', ')}"
                                          : "${trans().amenity}: ${trans().noAmenities}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${trans().price}: ${room.pricePerNight.toStringAsFixed(2)} ${trans().riyalY}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {},
                          child: Center(
                            child: Text(
                              trans().bookingNow,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
