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

    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
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
      
              SizedBox(
                width: 300,
                child: TextField(
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
                    counterText: '',
                    hintText: '------',
                    hintStyle:
                    TextStyle(color: colorScheme.onSurface.withOpacity(0.4)),
      
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
      
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
      
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: (val) =>
                  ref.read(otpCodeProvider.notifier).state = val,
                ),
              ),
              const SizedBox(height: 20),
              Button(
                width: double.infinity,
                title: isSubmitting ? 'جاري التحقق…' : trans().verify,
                disable: isSubmitting,
                icon: const Icon(truesIcon, color: Colors.white),
                iconAfterText: true,
                onPressed: () async {
                  if (isSubmitting) return;
      
                  if (otp.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('الرجاء إدخال رمز مكوّن من 6 أرقام'),
                      ),
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
      ),
    );
  }
}
