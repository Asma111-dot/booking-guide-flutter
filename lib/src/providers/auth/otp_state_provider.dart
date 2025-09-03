import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The phone number entered by the user
final phoneProvider = StateProvider<String>((ref) => '');

/// The OTP code entered by the user
final otpCodeProvider = StateProvider<String>((ref) => '');

/// The authentication token received after successful login
final authTokenProvider = StateProvider<String?>((ref) => null);

/// Flag to prevent multiple OTP submissions at the same time
final otpSubmittingProvider = StateProvider.autoDispose<bool>((ref) => false);
