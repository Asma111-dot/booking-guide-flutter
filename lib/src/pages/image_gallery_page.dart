import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../helpers/general_helper.dart';
import '../models/media.dart';
import '../utils/assets.dart';
import '../widgets/custom_app_bar.dart';
import 'full_screen_image_page.dart';
import 'video_fullscreen_page.dart';

class ImageGalleryPage extends StatelessWidget {
  final List<Media> mediaList;
  final int initialIndex;

  const ImageGalleryPage({
    super.key,
    required this.mediaList,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        appTitle: trans().imageGallery,
        icon: arrowBackIcon,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: mediaList.length,
        itemBuilder: (context, index) {
          final media = mediaList[index];
          final isVideo = media.mime_type?.startsWith('video') ?? false;

          return GestureDetector(
            onTap: () {
              if (isVideo) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoFullScreenPage(videoUrl: media.original_url),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImagePage(
                      imageUrls: mediaList
                          .where((m) => !(m.mime_type?.startsWith('video') ?? false))
                          .map((m) => m.original_url)
                          .toList(),
                      initialIndex: mediaList
                          .where((m) => !(m.mime_type?.startsWith('video') ?? false))
                          .toList()
                          .indexOf(media),
                    ),
                  ),
                );
              }
            },
            child: isVideo
                ? Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.black26,
                  child: const Icon(Icons.videocam, size: 48, color: Colors.white),
                ),
                const Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
              ],
            )
                : CachedNetworkImage(
              imageUrl: media.original_url,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
