import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../helpers/general_helper.dart';
import '../utils/amenity_icon_helper.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../providers/room/room_provider.dart';
import '../models/facility.dart';
import '../models/room.dart' as r;
import '../widgets/room_price_widget.dart';
import '../widgets/video_widget.dart';
import '../widgets/view_widget.dart';
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
  Timer? imageTimer;
  late GoogleMapController mapController;
  final GlobalKey _descKey = GlobalKey();
  final GlobalKey _typeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();

  bool showAboutFull = false;
  bool showTypeFull = false;
  bool showDescFull = false;

  bool showReadMore = false;

  @override
  void initState() {
    super.initState();

    // تحميل بيانات الغرفة
    Future.microtask(() async {
      final roomId = widget.facility.firstRoomId;
      if (roomId != null) {
        await ref.read(roomProvider.notifier).fetch(roomId: roomId);
        final data = ref.read(roomProvider).data;
        if (data == null) {
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
  bool isOverflowingText(String text, TextStyle style, double maxWidth, int maxLines) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.rtl,
    )..layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  bool isTextOverflowing(
      String text, TextStyle style, double maxWidth, int maxLines) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.rtl,
      maxLines: maxLines,
    );
    tp.layout(maxWidth: maxWidth);
    return tp.didExceedMaxLines;
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
        refresh: () async {
          final roomId = widget.facility.firstRoomId;
          if (roomId != null) {
            await ref.read(roomProvider.notifier).fetch(roomId: roomId);
          }
        },
        forceShowLoaded: roomState.data != null,
        onLoaded: (room) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final descHeight = _descKey.currentContext?.size?.height ?? 0;
            final typeHeight = _typeKey.currentContext?.size?.height ?? 0;
            final aboutHeight = _aboutKey.currentContext?.size?.height ?? 0;

            if (descHeight > 50 || typeHeight > 50 || aboutHeight > 50) {
              setState(() => showReadMore = true);
            }
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final textStyle = const TextStyle(fontSize: 16);
            final maxWidth =
                MediaQuery.of(context).size.width - 32; // حسب Padding

            final overflowing = isTextOverflowing(
              "${widget.facility.desc}\n${room.type}\n${room.desc}",
              textStyle,
              maxWidth,
              2,
            );

            if (overflowing && !showReadMore) {
              setState(() => showReadMore = true);
            }
          });

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
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
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
                    color: Colors.white.withValues(alpha: 150),
                    // 178 ≈ 0.7 * 255
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: CustomTheme.color2,
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
                    color: Colors.white.withValues(alpha: 150),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.share,
                      color: CustomTheme.color2,
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
                            widget.facility.name,
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
                                color: CustomTheme.color2,
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Text(
                                widget.facility.address?.toString() ??
                                    trans().address_not_available,
                                style: TextStyle(
                                  color: CustomTheme.color3,
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
                            isScrollable: true,
                            labelColor: CustomTheme.primaryColor,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: CustomTheme.color2,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            tabs: [
                              Tab(text: trans().description),
                              Tab(text: trans().amenity),
                              Tab(text: trans().price_list),
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 🏡 عن الشاليه
                                        // Text(
                                        //   trans().about_facility,
                                        //   style: const TextStyle(
                                        //     fontSize: 18,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: CustomTheme.primaryColor,
                                        //   ),
                                        // ),
                                        // 🏡 عن الشاليه
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              trans().about_facility,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              widget.facility.desc,
                                              style: const TextStyle(fontSize: 16),
                                              maxLines: showAboutFull ? null : 2,
                                              overflow: showAboutFull ? TextOverflow.visible : TextOverflow.ellipsis,
                                            ),
                                            if (widget.facility.desc.length > 150)
                                              TextButton(
                                                onPressed: () => setState(() => showAboutFull = !showAboutFull),
                                                child: Text(showAboutFull ? 'عرض أقل' : 'قراءة المزيد'),
                                              ),
                                          ],
                                        ),

                                        const Divider(color: Colors.grey, thickness: 1),
                                        const SizedBox(height: 8),

// 📜 شروط وسياسات المكان
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              trans().read_terms_before_booking,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              room.type,
                                              style: const TextStyle(fontSize: 16),
                                              maxLines: showTypeFull ? null : 2,
                                              overflow: showTypeFull ? TextOverflow.visible : TextOverflow.ellipsis,
                                            ),
                                            if (room.type.length > 150)
                                              TextButton(
                                                onPressed: () => setState(() => showTypeFull = !showTypeFull),
                                                child: Text(showTypeFull ? 'عرض أقل' : 'قراءة المزيد'),
                                              ),
                                          ],
                                        ),

                                        const Divider(color: Colors.grey, thickness: 1),
                                        const SizedBox(height: 8),

// 🛡️ التأمين على ممتلكات المكان
                                        StatefulBuilder(
                                          builder: (context, localSetState) {
                                            final text = room.desc;
                                            final textStyle = const TextStyle(fontSize: 16);

                                            return LayoutBuilder(
                                              builder: (context, constraints) {
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  final textPainter = TextPainter(
                                                    text: TextSpan(text: text, style: textStyle),
                                                    textDirection: TextDirection.rtl,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                  )..layout(maxWidth: constraints.maxWidth);

                                                  final lines = textPainter.computeLineMetrics();
                                                  final isOverflowing = lines.length > 2;

                                                  if (isOverflowing && !showDescFull && mounted) {
                                                    localSetState(() {}); // لإجبار إعادة البناء
                                                  }
                                                });

                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      trans().insurance_coverage_question,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: CustomTheme.primaryColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      text,
                                                      style: textStyle,
                                                      textAlign: TextAlign.start,
                                                      maxLines: showDescFull ? null : 2,
                                                      overflow: showDescFull ? TextOverflow.visible : TextOverflow.ellipsis,
                                                    ),
                                                    if (text.length > 150) // أو اجعلها isOverflowing إذا اشتغلت
                                                      TextButton(
                                                        onPressed: () => localSetState(() => showDescFull = !showDescFull),
                                                        child: Text(showDescFull ? 'عرض أقل' : 'قراءة المزيد'),
                                                      ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 🛏️ العنوان: المساحات المتوفرة
                                        Text(
                                          trans().available_spaces,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: CustomTheme.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 6),

                                        ...(room.availableSpaces).map((space) {
                                          final type = space['type'] ?? '';
                                          final count = int.tryParse(
                                                  space['count'].toString()) ??
                                              1;
                                          final icon =
                                              AmenityIconHelper.getAmenityIcon(
                                                  type);

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  icon,
                                                  size: 18,
                                                  color: CustomTheme.color2,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    count > 1
                                                        ? '$count $type'
                                                        : '$type',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: CustomTheme
                                                          .primaryColor,
                                                    ),
                                                    softWrap: true,
                                                    maxLines: null,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),

                                        const Divider(
                                            color: Colors.grey, thickness: 1),
                                        const SizedBox(height: 12),

                                        // 🛎️ العنوان: وسائل الراحة
                                        Text(
                                          trans().amenities_and_facilities,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: CustomTheme.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        room.amenities.isNotEmpty
                                            ? Column(
                                                children:
                                                    room.amenities.map((a) {
                                                  final icon = AmenityIconHelper
                                                      .getAmenityIcon(a.name);

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          icon,
                                                          size: 18,
                                                          color: CustomTheme
                                                              .color2,
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Expanded(
                                                          child: Text(
                                                            a.name,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              color: CustomTheme
                                                                  .primaryColor,
                                                            ),
                                                            softWrap: true,
                                                            maxLines: null,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Text(
                                                  "${trans().amenity}: ${trans().noAmenities}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: CustomTheme.color2,
                                                  ),
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
                                                  color: CustomTheme.color2),
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
