import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

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
      nameController.text = user.name ;
      emailController.text = user.email ;
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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
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
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// صورة المستخدم
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: CustomTheme.tertiaryColor,
                  backgroundImage: selectedImage != null
                      ? FileImage(selectedImage!)
                      : (user.getAvatarUrl() != null
                      ? NetworkImage(user.getAvatarUrl()!) as ImageProvider
                      : const AssetImage('assets/images/default_avatar.jpg')),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ElevatedButton(
                    onPressed: pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      elevation: 4,
                      shadowColor: Colors.grey.shade400,
                    ),
                    child: Icon(Icons.camera_alt_outlined,
                        size: 18, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            _buildTextField(
                controller: nameController, label: trans().fullName),
            const SizedBox(height: 20),
            _buildTextField(controller: emailController, label: trans().email),
            const SizedBox(height: 20),
            _buildTextField(
                controller: addressController, label: trans().address),

            const SizedBox(height: 30),

            /// حذف الحساب
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(trans().are_you_sure),
                    content: Text(trans().delete_account_confirmation),
                    actions: [
                      TextButton(
                        child: Text(trans().cancel),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: Text(trans().yes),
                        onPressed: () => Navigator.pop(context, true),
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

            const SizedBox(height: 20),

            /// أزرار الحفظ والإلغاء
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedUser = user.copyWith(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        address: addressController.text.trim(),
                      );

                      await ref.read(userProvider.notifier).updateUser(
                        updatedUser,
                        selectedImage, // ✅ تمرير الصورة هنا
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      side: BorderSide(color: CustomTheme.primaryColor),
                    ),
                    child: Text(
                      trans().save,
                      style: TextStyle(color: CustomTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      trans().cancel,
                      style: const TextStyle(color: Colors.black),
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

  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CustomTheme.primaryColor, width: 1.5),
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
