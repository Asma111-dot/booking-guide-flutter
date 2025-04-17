import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../providers/auth/otp_state_provider.dart';
import '../providers/auth/login_provider.dart';
import 'button_widget.dart';

class OtpVerifySheet extends ConsumerWidget {
  const OtpVerifySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otp = ref.watch(otpCodeProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Text(
            trans().otp_code,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
           Text(
             trans().enter_verification_code_message,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 6),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              counterText: '',
              hintText: '------',
            ),
            onChanged: (val) => ref.read(otpCodeProvider.notifier).state = val,
          ),
          const SizedBox(height: 20),
          Button(
            width: double.infinity,
            title: trans().verify,
            disable: otp.length != 6,
            icon: const Icon(Icons.check, color: Colors.white),
            iconAfterText: true,
            onPressed: () async {
              if (otp.length == 6) {
                await ref.read(loginProvider.notifier).loginWithOtp();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرجاء إدخال رمز مكوّن من 6 أرقام')),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
