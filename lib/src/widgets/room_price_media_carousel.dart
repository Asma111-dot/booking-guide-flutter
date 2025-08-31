import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/media.dart';
import '../helpers/general_helper.dart';
import '../pages/image_gallery_page.dart';
import '../utils/sizes.dart';
import 'shimmer_image_placeholder.dart';
import 'video_widget.dart';

class RoomPriceMediaCarousel extends StatefulWidget {
  final List<Media> media;
  final double height;

  const RoomPriceMediaCarousel({
    super.key,
    required this.media,
    this.height = 150,
  });

  @override
  State<RoomPriceMediaCarousel> createState() => _RoomPriceMediaCarouselState();
}

class _RoomPriceMediaCarouselState extends State<RoomPriceMediaCarousel> {
  late final PageController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1);
    // Auto-slide كل 3 ثواني (يتوقف لو عنصر واحد)
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || widget.media.length <= 1 || !_controller.hasClients) return;
      final current = _controller.page?.round() ?? 0;
      final last = widget.media.length - 1;
      if (current >= last) {
        _controller.jumpToPage(0);
      } else {
        _controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.media.isNotEmpty ? widget.media.length : 1,
            itemBuilder: (context, index) {
              if (widget.media.isEmpty) {
                return Center(child: Text(trans().no_images));
              }

              final m = widget.media[index];
              final isVideo = (m.mime_type ?? '').toLowerCase().startsWith('video');
              final url = m.original_url;

              if (isVideo) {
                return VideoWidget(videoUrl: url);
              }

              final heroTag = url.isNotEmpty
                  ? 'media-hero-$url'
                  : 'media-$index-${m.id}';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageGalleryPage(
                        mediaList: widget.media,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: heroTag,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (ctx, u) => const ShimmerImagePlaceholder(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    errorWidget: (ctx, u, e) =>
                    const Icon(Icons.broken_image_outlined),
                  ),
                ),
              );
            },
          ),

          PositionedDirectional(
            top: Insets.s12,
            start: Insets.s12,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                final total = widget.media.isEmpty ? 1 : widget.media.length;
                int page = 0;
                if (_controller.hasClients) {
                  final p = _controller.page;
                  page = p == null ? 0 : p.round();
                }
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: S.w(10),
                    vertical: S.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: Corners.sm8,
                  ),
                  child: Text(
                    "${(page + 1).clamp(1, total)}/$total",
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
