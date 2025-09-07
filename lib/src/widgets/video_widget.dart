import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../utils/assets.dart';
import '../utils/sizes.dart';

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  const VideoWidget({super.key, required this.videoUrl});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        VideoProgressIndicator(_controller, allowScrubbing: true),
        Positioned(
          bottom: S.r(40),
          child: IconButton(
            icon: Icon(
              _controller.value.isPlaying ? pauseIcon : playArrowIcon,
              size: Sizes.avatarM48,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _controller.value.isPlaying ? _controller.pause() : _controller.play();
              });
            },
          ),
        ),
      ],
    );
  }
}
/// أزرار الحفظ والإلغاء Row( children: [ Expanded( child: Container( decoration: BoxDecoration( gradient: CustomTheme.primaryGradient, borderRadius: Corners.sm8, ), child: ElevatedButton( onPressed: () async { final updatedUser = user.copyWith( name: nameController.text.trim(), email: emailController.text.trim(), address: addressController.text.trim(), ); await ref.read(userProvider.notifier).updateUser( updatedUser, selectedImage, ); }, style: ElevatedButton.styleFrom( backgroundColor: Colors.transparent, shadowColor: Colors.transparent, elevation: 0, shape: RoundedRectangleBorder( borderRadius: Corners.sm8, ), ), child: Text( trans().save, style: const TextStyle(color: Colors.white), ), ), ), ), const SizedBox(width: 15), Expanded( child: Container( decoration: BoxDecoration( gradient: CustomTheme.primaryGradient, borderRadius: Corners.sm8, ), child: ElevatedButton( onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom( backgroundColor: Colors.transparent, shadowColor: Colors.transparent, elevation: 0, shape: RoundedRectangleBorder( borderRadius: Corners.sm8, ), ), child: Text( trans().cancel, style: const TextStyle(color: Colors.white), ), ), ), ), ],