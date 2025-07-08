import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/general_helper.dart';
import '../../helpers/notify_helper.dart';
import '../../models/response/response.dart';
import '../../models/user.dart' as model;
import '../../pages/complete_profile_page.dart';
import '../../pages/navigation_menu.dart';
import '../../services/request_service.dart';
import '../../storage/auth_storage.dart';
import '../../utils/routes.dart';
import '../../utils/urls.dart';
import 'otp_state_provider.dart';
import 'user_provider.dart';

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
    final englishCode = convertToEnglishNumbers(code);

    final body = {
      'phone': phone,
      'code': englishCode.toString(),
    };

    print("🚀 إرسال التحقق بـ: $body");

    final value = await request<model.User>(
      url: otpVerifyUrl(),
      method: Method.post,
      body: body,
    );

    print("📥 Response Meta: ${value.meta.toJson()}");

    state = state.copyWith(meta: value.meta);

    if (value.isLoaded()) {
      await onSuccessLogin(value);
    } else {
      // عرض الخطأ للمستخدم
      showNotify(
        alert: Alert.error,
        message: value.meta.message ?? 'فشل تسجيل الدخول',
      );
    }
  }


  Future<bool> completeProfile({
    required String name,
    required String email,
    String? address,
    String? password,
    File? avatarFile,
  }) async {
    showLoading();

    final result = await request<model.User>(
      url: completeProfileUrl(),
      method: Method.post,
      isMultipart: true,
      file: avatarFile,
      fileFieldName: 'avatar',
      fields: {
        'name': name,
        'email': email,
        'address': address ?? '',
        if (password != null && password.isNotEmpty) 'password': password,
      },
      showSuccessMessage: false,
      showErrorMessage: true,
    );

    hideLoading();

    if (result.isLoaded() && result.data != null) {
      await ref.read(userProvider.notifier).saveUserLocally(result.data!);
      return true;
    }

    return false;
  }

  Future<void> onSuccessLogin(Response<model.User> value) async {
    final user = value.data;

    if (user == null) {
      showNotify(
        alert: Alert.error,
        message: 'المستخدم غير موجود في البيانات!',
      );
      return;
    }

    final token = value.meta.accessToken;
    if (token == null || token.isEmpty) {
      showNotify(
        alert: Alert.error,
        message: 'لم يتم استلام رمز الدخول!',
      );
      return;
    }

    print("🔐 Token: $token");
    await setToken(token); // تأكد من أنها async وتنتظر

    await open(); // فتح الصندوق
    await ref.read(userProvider.notifier).saveUserLocally(user);

    final name = user.name.trim().toLowerCase();
    final email = user.email.trim().toLowerCase();

    final isTemporaryProfile =
        name == 'temporary name' || email.startsWith('phone_');

    await setLoggedIn(true);
    await setFirstTimeFalse();

    final navigator = navKey.currentState;
    if (navigator == null) {
      print("❌ navKey.currentState is null!");
      return;
    }

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) =>
        isTemporaryProfile ? const CompleteProfilePage() : const NavigationMenu(),
      ),
          (r) => false,
    );
  }

}
