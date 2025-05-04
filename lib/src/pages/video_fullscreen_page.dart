import 'package:flutter/material.dart';
import '../widgets/video_widget.dart';

class VideoFullScreenPage extends StatelessWidget {
  final String videoUrl;

  const VideoFullScreenPage({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: VideoWidget(videoUrl: videoUrl),
      ),
    );
  }
}
