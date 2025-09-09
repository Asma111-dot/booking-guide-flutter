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
import '../utils/sizes.dart';
import '../utils/theme.dart';
import '../helpers/general_helper.dart';
import '../widgets/full_map_widget.dart';
import '../widgets/room_details_shimmer.dart';
import '../widgets/shimmer_image_placeholder.dart';
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
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: Button(
        width: double.infinity,
        disable: false,
        onPressed: () async{
          final room = ref.read(roomProvider).data;
          if (room?.id != null) {
            Navigator.pushNamed(
              context,
              Routes.priceAndCalendar,
              arguments: room!.id,
            );
          }
        },
        title: trans().showAvailableDays,
        icon: Icon(
          periodIcon,
          size: Sizes.iconM20,
          color: colorScheme.onPrimary,
        ),
      ),
      //if you went add SafeArea
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
                  height: S.h(400),
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
                              placeholder: (context, url) =>
                                  const ShimmerImagePlaceholder(
                                      width: 80, height: 80),
                              errorWidget: (context, url, error) =>
                                   Icon(brokenImageIcon,color: colorScheme.error,),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              PositionedDirectional(
                top: topPad + 10,
                start: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.8),
                    borderRadius: Corners.sm8,
                  ),
                  child: IconButton(
                    icon: Icon(arrowBacksIcon, color: colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              PositionedDirectional(
                top: topPad + 10,
                end: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.8),
                    borderRadius: Corners.sm8,
                  ),
                  child: IconButton(
                    icon: Icon(shareIcon, color: colorScheme.onSurface),
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
                top: S.h(200),
                left: S.w(10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.s12,
                    vertical: Insets.xxs6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: Corners.sm8,
                  ),
                  child: Text(
                    "${pageController.positions.isNotEmpty ? (pageController.page?.toInt() ?? 0) + 1 : 1}/${room.media.length}",
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: TFont.m14,
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
                    padding: EdgeInsets.all(Insets.m16),
                    decoration: BoxDecoration(
                      color: colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.1),
                          blurRadius: S.r(10),
                          offset: Offset(0, -S.h(4)),
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
                            style:  TextStyle(
                              fontSize: TFont.xl18,
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.color4,
                            ),
                          ),
                          Gaps.h8,
                          Row(
                            children: [
                              Icon(mapIcon,
                                  color: colorScheme.primary, size: Sizes.iconM20),
                              Gaps.w4,
                              Expanded(
                                child: Text(
                                  widget.facility.address ??
                                      trans().address_not_available,
                                  style:  TextStyle(
                                    color: CustomTheme.color3,
                                    fontSize: TFont.s12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              IconButton(
                                icon:
                                    Icon(map2Icon, color: colorScheme.primary),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullMapWidget(
                                        latitude: widget.facility.latitude,
                                        longitude: widget.facility.longitude,
                                        name: widget.facility.name,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Gaps.h12,
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: RoomDetailsTabs(
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
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
        onLoading: () => const RoomDetailsShimmer(),
        onEmpty: () => Center(child: Text(trans().no_data)),
        showError: true,
        showEmpty: true,
      ),
    );
  }
}
