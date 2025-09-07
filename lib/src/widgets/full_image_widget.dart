import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/assets.dart';

class FullImageWidget extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullImageWidget({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(goBackIcon, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Center(
            child: Hero(
              tag: imageUrls[index],
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                 Icon(errorIcon, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
