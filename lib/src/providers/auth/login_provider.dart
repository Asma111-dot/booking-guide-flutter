import 'dart:convert';
import 'dart:io';

import 'package:booking_guide/src/providers/auth/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/response/response.dart';
import '../../models/user.dart' as model;
import '../../pages/complete_profile_page.dart';
import '../../pages/navigation_menu.dart';
import '../../services/request_service.dart';
import '../../storage/auth_storage.dart';
import '../../utils/routes.dart';
import '../../utils/urls.dart';
import 'otp_state_provider.dart';

part 'login_provider.g.dart';

@Riverpod(keepAlive: true)
class Login extends _$Login {
  @override
  Response<model.User> build() => Response(data: model.User.init());

  Future<bool> requestOtp() async {
    final phone = ref.read(phoneProvider);

    if (phone.isEmpty) {
      print("📛 الهاتف فارغ");
      return false;
    }

    final response = await request<Map>(
      url: otpRequestUrl(),
      method: Method.post,
      body: {"phone": phone},
    );

    return response.isLoaded();
  }

  Future loginWithOtp() async {
    state = state.setLoading();

    final phone = ref.read(phoneProvider);
    final code = ref.read(otpCodeProvider);

    final body = {
      'phone': phone,
      'code': code,
    };

    print("🚀 إرسال التحقق بـ: $body");

    await request<model.User>(
      url: otpVerifyUrl(),
      method: Method.post,
      body: body,
    ).then((value) async {
      state = state.copyWith(meta: value.meta);

      if (value.isLoaded()) {
        await onSuccessLogin(value);
      }
    });
  }


  Future<bool> completeProfile({
    required String name,
    required String email,
    String? address,
    File? avatarFile,
  }) async {
    final token = await getToken();

    final uri = Uri.parse(completeProfileUrl());
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['address'] = address ?? '';

    if (avatarFile != null) {
      request.files.add(await http.MultipartFile.fromPath('avatar', avatarFile.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is Map<String, dynamic> && jsonData['data'] != null) {
        final parsedUser = model.User.fromJson(jsonData['data']);
        ref.read(userProvider.notifier).saveUserLocally(parsedUser);
        return true;
      }
     }

    return false;
  }


  Future<void> onSuccessLogin(Response<model.User> value) async {
    final user = value.data!;
    setToken(value.meta.accessToken ?? "");
    ref.read(userProvider.notifier).saveUserLocally(user);

    final name = user.name.trim().toLowerCase();
    final email = user.email.trim().toLowerCase();

    final isTemporaryProfile =
        name == 'temporary name' || email.startsWith('phone_');

    // حفظ حالة الدخول
    await setLoggedIn(true);
    await setFirstTimeFalse();

    navKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => isTemporaryProfile
            ? const CompleteProfileScreen()
            : const NavigationMenu(),
      ),
          (r) => false,
    );
  }
}
