import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import '../utils/theme.dart';
import '../widgets/avatar_picker.dart';
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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).data;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Insets.m16),
        child: Column(
          children: [
            Gaps.h20,
            AvatarPicker(
              initialImageUrl: user.getAvatarUrl(),
              onImageSelected: (file) {
                setState(() {
                  selectedImage = file;
                });
              },
            ),

            Gaps.h30,
            CustomTextField(
              controller: nameController,
              label: trans().fullName,
            ),
            Gaps.h20,

            CustomTextField(
              controller: emailController,
              label: trans().email,
            ),
            Gaps.h20,

            CustomTextField(
              controller: addressController,
              label: trans().address,
            ),

            Gaps.h30,

            /// زر حذف الحساب
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
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
                  ),
                );

                if (confirm == true) {
                  await ref.read(userProvider.notifier).deleteAccount(context);
                }
              },
              label: Text(
                trans().delete_account,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: Icon(deleteIcon, color: colorScheme.onSurface),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.surface,
                // أو Colors.transparent
                elevation: 0,
                side: BorderSide(color: colorScheme.error, width: 1),
                minimumSize: Size(double.infinity, S.h(50)),
                shape: RoundedRectangleBorder(
                  borderRadius: Corners.md15,
                ),
              ),
            ),

            S.gapH(40),

            /// أزرار الحفظ والإلغاء
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: CustomTheme.primaryGradient,
                      borderRadius: Corners.sm8,
                    ),
                    child: ElevatedButton(
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: Corners.sm8,
                        ),
                      ),
                      child: Text(
                        trans().save,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: CustomTheme.primaryGradient,
                      borderRadius: Corners.sm8,
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: Corners.sm8,
                        ),
                      ),
                      child: Text(
                        trans().cancel,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
