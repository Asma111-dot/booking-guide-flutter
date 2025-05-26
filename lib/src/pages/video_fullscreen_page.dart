import 'package:flutter/material.dart';
import '../utils/assets.dart';
import '../widgets/video_widget.dart';

class VideoFullScreenPage extends StatelessWidget {
  final String videoUrl;

  const VideoFullScreenPage({super.key, required this.videoUrl});

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
