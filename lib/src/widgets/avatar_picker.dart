import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/general_helper.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import '../utils/theme.dart';

class AvatarPicker extends StatefulWidget {
  final void Function(File image) onImageSelected;
  final String? initialImageUrl;

  const AvatarPicker({
    super.key,
    required this.onImageSelected,
    this.initialImageUrl,
  });

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  File? _avatarFile;

  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      final file = File(picked.path);
      setState(() {
        _avatarFile = file;
      });
      widget.onImageSelected(file);
    }
  }

  void showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(cameraSourceIcon),
              title:  Text(trans().pick_from_camera),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(gallerySourceIcon),
              title:  Text(trans().pick_from_gallery),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider get _avatarImage {
    if (_avatarFile != null) {
      return FileImage(_avatarFile!);
    } else if (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty) {
      return NetworkImage(widget.initialImageUrl!);
    } else {
      return const AssetImage(defaultAvatar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onTap: showImageSourcePicker,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _avatarImage,
                backgroundColor: CustomTheme.whiteColor,
              ),
               CircleAvatar(
                radius: 15,
                backgroundColor: CustomTheme.whiteColor,
                child: Icon(
                  cameraIcon,
                  size: Sizes.iconS16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
