import 'package:flutter/material.dart';
import '../utils/assets.dart';
import 'video_widget.dart';

class VideoFullWidget extends StatelessWidget {
  final String videoUrl;

  const VideoFullWidget({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(arrowBacksIcon, color: colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: VideoWidget(videoUrl: videoUrl),
      ),
    );
  }
}
