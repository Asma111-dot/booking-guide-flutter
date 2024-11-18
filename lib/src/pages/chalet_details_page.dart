import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/general_helper.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../providers/room/room_provider.dart';
import '../models/facility.dart';
import '../models/room.dart' as r;
import '../widgets/view_widget.dart';

class ChaletDetailsPage extends ConsumerStatefulWidget {
  final Facility facility;

  const ChaletDetailsPage({Key? key, required this.facility}) : super(key: key);

  @override
  _ChaletDetailsPageState createState() => _ChaletDetailsPageState();
}

class _ChaletDetailsPageState extends ConsumerState<ChaletDetailsPage>
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
            .fetch(facilityId: widget.facility.id),
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
                    itemCount: room.media.length,
                    controller: PageController(viewportFraction: 1),
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
                          const SizedBox(height: 8),
                          Text(
                            "${trans().capacity}: ${room.capacity}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${trans().status}: ${room.status}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
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
                            height: 120,
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      room.desc,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    room.amenity.isNotEmpty
                                        ? "${trans().amenity}: ${room.amenity.map((a) => a.name).join(', ')}"
                                        : "${trans().amenity}: ${trans().noAmenities}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${trans().price}: ${room.pricePerNight.toStringAsFixed(2)} ${trans().riyalY}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {},
                  child: Text(
                    trans().bookingNow,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
