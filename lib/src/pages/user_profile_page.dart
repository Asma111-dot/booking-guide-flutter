import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).data;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      addressController.text = user.address ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }


  Widget _buildDeleteDialog(BuildContext context, ColorScheme colorScheme) {
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        trans().are_you_sure,
        style: TextStyle(
          fontSize: TFont.m14,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
      content: Text(
        trans().delete_account_confirmation,
        style: TextStyle(
          fontSize: TFont.s12,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            trans().cancel,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            trans().verify,
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).data;
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        appTitle: trans().edit_personal_data,
        icon: arrowBackIcon,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Button(
                  title: trans().save,
                  icon: Icon(
                    saveIcon,
                    size: Sizes.iconM20,
                    color: theme.colorScheme.onPrimary,
                  ),
                  iconAfterText: true,
                  disable: false,
                  onPressed: () async {
                    final updatedUser = user.copyWith(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      address: addressController.text.trim(),
                    );

                    await ref.read(userProvider.notifier).updateUser(
                      updatedUser,
                      selectedImage,
                    );
                  },
                ),
              ),
              Gaps.w8,
              Expanded(
                child: Button(
                  title: trans().cancel,
                  icon: Icon(
                    closeIcon,
                    size: Sizes.iconM20,
                    color: theme.colorScheme.onPrimary,
                  ),
                  iconAfterText: true,
                  disable: false,
                  onPressed: () async => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          Insets.s12,
          Insets.s12,
          Insets.s12,
          S.h(12),
        ),
        child: Column(
          children: [
            Gaps.h20,
            AvatarPicker(
              initialImageUrl: user.getAvatarUrl(),
              onImageSelected: (file) => setState(() => selectedImage = file),
            ),
            Gaps.h30,
            CustomTextField(
                controller: nameController, label: trans().fullName),
            Gaps.h20,
            CustomTextField(controller: emailController, label: trans().email),
            Gaps.h20,
            CustomTextField(
                controller: addressController, label: trans().address),
            Gaps.h30,
            Gaps.h30,
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) =>
                      _buildDeleteDialog(context, theme.colorScheme),
                );
                if (confirm == true) {
                  await ref.read(userProvider.notifier).deleteAccount(context);
                }
              },
              label: Text(
                trans().delete_account,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: Icon(deleteIcon, color: theme.colorScheme.primary),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                elevation: 0,
                side: BorderSide(color: theme.colorScheme.error, width: 1),
                minimumSize: Size(double.infinity, S.h(50)),
                shape: RoundedRectangleBorder(borderRadius: Corners.md15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
