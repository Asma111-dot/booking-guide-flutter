import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/login_provider.dart';
import '../utils/theme.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_text_field.dart';
import 'navigation_menu.dart';

class CompleteProfilePage extends ConsumerStatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  ConsumerState<CompleteProfilePage> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  bool isLoading = false;
  File? _avatarFile;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    final isSuccess = await ref.read(loginProvider.notifier).completeProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      address: addressController.text.trim(),
      avatarFile: _avatarFile,
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const NavigationMenu()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل في حفظ البيانات، حاول مرة أخرى")),
      );
    }
    // print("✅ isSuccess = $isSuccess");
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: CustomTheme.placeholderColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            trans().completeProfile,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: CustomTheme.color2,
                  fontWeight: FontWeight.w200,
                ),
          ),
          elevation: 1,
          backgroundColor: CustomTheme.placeholderColor,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AvatarPicker(
                  onImageSelected: (file) {
                    setState(() {
                      _avatarFile = file;
                    });
                  },
                ),
                const SizedBox(height: 40),

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


                const SizedBox(height: 40),
                Button(
                  width: double.infinity,
                  title: trans().save,
                  disable: isLoading,
                  icon: const Icon(Icons.save_alt, color: Colors.white),
                  iconAfterText: true,
                  onPressed: submit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
