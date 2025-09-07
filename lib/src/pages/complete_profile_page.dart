import 'dart:io';

import 'package:booking_guide/src/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/login_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_text_field.dart';

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
  final passwordController = TextEditingController();
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
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (isSuccess) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.navigationMenu,
        (route) => false,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            trans().completeProfile,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: TFont.x2_20,
            ),
          ),
          elevation: 1,
          backgroundColor: colorScheme.background,
          iconTheme: IconThemeData(color: colorScheme.onBackground),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Insets.l20),
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
                Gaps.h20,
                CustomTextField(
                  controller: passwordController,
                  label: trans().password,
                  obscureText: true,
                ),
                Gaps.h30,
              ],
            ),
          ),
        ),
        bottomNavigationBar: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Button(
              width: double.infinity,
              title: trans().save,
              disable: isLoading,
              icon: Icon(saveIcon, color: colorScheme.onPrimary),
              iconAfterText: true,
              onPressed: submit,
            ),
          ),
        ),
      ),
    );
  }
}
