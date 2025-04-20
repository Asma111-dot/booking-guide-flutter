import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../helpers/general_helper.dart';
import '../providers/auth/login_provider.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import 'navigation_menu.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String address = '';
  bool isLoading = false;
  File? _avatarFile;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _avatarFile = File(picked.path);
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    final isSuccess = await ref.read(loginProvider.notifier).completeProfile(
      name: name,
      email: email,
      address: address,
      avatarFile: _avatarFile,
    );

    if (!mounted) return; // ✅ مهم جدًا في حال الشاشة تغيرت قبل ما يرجع الرد

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
    print("✅ isSuccess = $isSuccess");
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            trans().completeProfile,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: CustomTheme.primaryColor,
              fontWeight: FontWeight.w200,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _avatarFile != null
                                ? FileImage(_avatarFile!)
                                : AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
                            backgroundColor: CustomTheme.tertiaryColor,
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                TextFormField(
                  decoration: _inputDecoration(trans().fullName),
                  validator: (value) => value!.isEmpty ? trans().nameFieldIsRequired : null,
                  onSaved: (value) => name = value!,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  decoration: _inputDecoration(trans().email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? trans().emailFieldIsRequired : null,
                  onSaved: (value) => email = value!,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  decoration: _inputDecoration(trans().address_optional),
                  onSaved: (value) => address = value ?? trans().not_available,
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }
}
