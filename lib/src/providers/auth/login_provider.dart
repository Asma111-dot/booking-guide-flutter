import 'package:booking_guide/src/providers/auth/user_provider.dart';
import 'package:flutter/material.dart';
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
  }) async {
    final response = await request<model.User>(
      url: completeProfileUrl(),
      method: Method.post,
      body: {
        "name": name,
        "email": email,
        "address": address,
      },
    );

    if (response.isLoaded()) {
      ref.read(userProvider.notifier).saveUserLocally(response.data!);
    }

    return response.isLoaded();
  }

  Future<void> onSuccessLogin(Response<model.User> value) async {
    final user = value.data!;
    setToken(value.meta.accessToken ?? "");
    ref.read(userProvider.notifier).saveUserLocally(user);

    final name = user.name.trim().toLowerCase();
    final email = user.email.trim().toLowerCase();

    final isTemporaryProfile =
        name == 'temporary name' || email.startsWith('phone_');

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

