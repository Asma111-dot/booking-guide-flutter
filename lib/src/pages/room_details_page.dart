import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';

import '../models/facility.dart';
import '../models/room.dart' as r;
import '../providers/room/room_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../helpers/general_helper.dart';
import '../widgets/view_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/video_widget.dart';
import '../widgets/room_details_tabs.dart';
import 'image_gallery_page.dart';

class RoomDetailsPage extends ConsumerStatefulWidget {
  final Facility facility;

  const RoomDetailsPage({super.key, required this.facility});

  @override
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends ConsumerState<RoomDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  late GoogleMapController mapController;
  Timer? imageTimer;

  bool showAboutFull = false;
  bool showTypeFull = false;
  bool showDescFull = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final roomId = widget.facility.firstRoomId;
      if (roomId != null) {
        await ref.read(roomProvider.notifier).fetch(roomId: roomId);
        if (ref.read(roomProvider).data == null) {
          ref.read(roomProvider.notifier).setEmpty();
        }
      } else {
        ref.read(roomProvider.notifier).setEmpty();
      }
    });

    tabController = TabController(length: 3, vsync: this);
    pageController = PageController(viewportFraction: 1);
    pageController.addListener(() {
      setState(() {});
    });

    imageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final room = ref.read(roomProvider).data;
      if (pageController.hasClients && room != null && room.media.isNotEmpty) {
        final currentPage = pageController.page?.round() ?? 0;
        final lastPage = room.media.length - 1;

        if (currentPage >= lastPage) {
          pageController.jumpToPage(0);
        } else {
          pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ViewWidget<r.Room>(
        meta: roomState.meta,
        data: roomState.data,
        refresh: () async {
          final roomId = widget.facility.firstRoomId;
          if (roomId != null) {
            await ref.read(roomProvider.notifier).fetch(roomId: roomId);
          }
        },
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
                    itemCount: room.media.isNotEmpty ? room.media.length : 1,
                    itemBuilder: (context, index) {
                      if (room.media.isEmpty) {
                        return Center(child: Text(trans().no_images));
                      }
                      final media = room.media[index];
                      final isVideo =
                          media.mime_type?.startsWith('video') ?? false;
                      final mediaUrl = media.original_url;

                      if (isVideo) {
                        return VideoWidget(videoUrl: mediaUrl);
                      } else {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageGalleryPage(
                                  mediaList: room.media,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: mediaUrl,
                            child: CachedNetworkImage(
                              imageUrl: mediaUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(errorIcon),
                            ),
                          ),
                        );
                      }
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
                    color: colorScheme.surface.withOpacity(0.8),
                    // 178 ≈ 0.7 * 255
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(
                      arrowBacksIcon,
                      color: colorScheme.onSurface,
                    ),
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
                    color: colorScheme.surface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(
                      shareIcon,
                      color: colorScheme.onSurface,
                    ),
                    onPressed: () async {
                      final room = ref.read(roomProvider).data;
                      final text =
                          "شاهد هذه المنشأة في تطبيقنا: ${room?.facility?.name ?? ''} \n📍 ${room?.facility?.address ?? ''}\nرابط المنشأة: https://myapp.com/room";
                      await Share.share(text);
                    },
                  ),
                ),
              ),
              Positioned(
                top: 170,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3 * 255),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "${pageController.positions.isNotEmpty ? (pageController.page?.toInt() ?? 0) + 1 : 1}/${room.media.length}",
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.70,
                minChildSize: 0.70,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.1),
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
                            widget.facility.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(mapIcon,
                                  color: colorScheme.onSurface, size: 20),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.facility.address ??
                                      trans().address_not_available,
                                  style: const TextStyle(
                                    color: CustomTheme.color3,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 100,
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
                              onMapCreated: (controller) =>
                                  mapController = controller,
                            ),
                          ),
                          const SizedBox(height: 16),
                          RoomDetailsTabs(
                            room: room,
                            facility: widget.facility,
                            tabController: tabController,
                            showAboutFull: showAboutFull,
                            showTypeFull: showTypeFull,
                            showDescFull: showDescFull,
                            onShowAboutToggle: (val) =>
                                setState(() => showAboutFull = val),
                            onShowTypeToggle: (val) =>
                                setState(() => showTypeFull = val),
                            onShowDescToggle: (val) =>
                                setState(() => showDescFull = val),
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
                child: Button(
                  width: double.infinity,
                  disable: false,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.priceAndCalendar,
                    arguments: room.id,
                  ),
                  title: trans().showAvailableDays,
                  icon:
                      Icon(periodIcon, size: 20, color: colorScheme.onPrimary),
                ),
              ),
            ],
          );
        },
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () => Center(child: Text(trans().no_data)),
        showError: true,
        showEmpty: true,
      ),
    );
  }
}
