import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../utils/assets.dart';
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

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: trans().edit_personal_data,
        icon: arrowBackIcon,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            AvatarPicker(
              initialImageUrl: user.getAvatarUrl(),
              onImageSelected: (file) {
                setState(() {
                  selectedImage = file;
                });
              },
            ),

            const SizedBox(height: 30),

            CustomTextField(
              controller: nameController,
              label: trans().fullName,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              controller: emailController,
              label: trans().email,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              controller: addressController,
              label: trans().address,
            ),

            const SizedBox(height: 30),

            /// حذف الحساب
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      trans().are_you_sure,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.color2,
                      ),
                    ),
                    content: Text(
                      trans().delete_account_confirmation,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.primaryColor,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          trans().cancel,
                          style: TextStyle(
                            color: CustomTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          trans().verify,
                          style: TextStyle(
                            color: Colors.grey[700],
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
                style: TextStyle(color: Colors.red.shade700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 2,
                side: BorderSide(color: Colors.red.shade700),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.delete_forever, color: Colors.red.shade700),
            ),

            const SizedBox(height: 40),

            /// أزرار الحفظ والإلغاء
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: CustomTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
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
                          borderRadius: BorderRadius.circular(8),
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
