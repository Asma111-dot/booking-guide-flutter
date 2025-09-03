import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../providers/auth/otp_state_provider.dart';
import '../providers/auth/login_provider.dart';
import '../utils/assets.dart';
import '../widgets/button_widget.dart';

class OtpVerifySheet extends ConsumerWidget {
  const OtpVerifySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otp = ref.watch(otpCodeProvider);
    final isSubmitting = ref.watch(otpSubmittingProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trans().otp_code,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              trans().enter_verification_code_message,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // حقل الكود
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                letterSpacing: 6,
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                counterText: '',
                hintText: '------',
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.4)),
              ),
              onChanged: (val) => ref.read(otpCodeProvider.notifier).state = val,
              onSubmitted: (val) async {
                if (val.length == 6 && !ref.read(otpSubmittingProvider)) {
                  ref.read(otpSubmittingProvider.notifier).state = true;
                  try {
                    await ref.read(loginProvider.notifier).loginWithOtp();
                  } finally {
                    ref.read(otpSubmittingProvider.notifier).state = false;
                  }
                }
              },
            ),
            const SizedBox(height: 20),

            // زر التحقق مع تعطيل أثناء الإرسال
            Button(
              width: double.infinity,
              title: isSubmitting ? 'جاري التحقق…' : trans().verify,
              disable: isSubmitting || otp.length != 6,
              icon: const Icon(truesIcon, color: Colors.white),
              iconAfterText: true,
              onPressed: () async {
                if (isSubmitting) return;                 // حماية إضافية
                if (otp.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('الرجاء إدخال رمز مكوّن من 6 أرقام')),
                  );
                  return;
                }

                ref.read(otpSubmittingProvider.notifier).state = true;
                try {
                  await ref.read(loginProvider.notifier).loginWithOtp();
                } finally {
                  ref.read(otpSubmittingProvider.notifier).state = false;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
