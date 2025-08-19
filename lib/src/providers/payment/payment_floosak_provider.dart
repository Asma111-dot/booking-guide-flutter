import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/payment.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'payment_floosak_provider.g.dart';

@Riverpod(keepAlive: false)
class PaymentFloosak extends _$PaymentFloosak {
  @override
  Response<Payment> build() => const Response<Payment>();

  /// ✅ الخطوة 1: تهيئة الدفع عبر Floosak
  Future<void> initiateFloosakPayment({
    required int reservationId,
    required int paymentMethodId, // غالبًا floosak id من الـ config
  }) async {
    state = state.setLoading();

    try {
      final response = await request<Payment>(
        url: floosakInitiateUrl(),     // => /api/floosak-payment/initiate
        method: Method.post,           // دومًا POST
        body: {
          'reservation_id': reservationId,
          'payment_method_id': paymentMethodId,
        },
      );

      debugPrint("📤 [Floosak] Initiating payment for reservation: $reservationId");

      state = response;

      if (response.isLoaded()) {
        debugPrint("✅ [Floosak] Payment initiation successful.");
      } else {
        debugPrint("❌ [Floosak] Payment initiation failed: ${response.meta.message}");
      }
    } catch (e, s) {
      debugPrint("❌ [Floosak] Exception during initiation: $e\n$s");
      state = state.setError("Error while initiating Floosak payment: $e");
    }
  }

  /// ✅ الخطوة 2: تأكيد الدفع عبر Floosak (OTP)
  Future<void> confirmFloosakPayment({
    required int paymentId,
    required int otp,
  }) async {
    state = state.setLoading();

    try {
      final response = await request<Payment>(
        url: floosakConfirmUrl(paymentId), // => /api/floosak-payment/{payment}/confirm
        method: Method.post,
        body: {'otp': otp},
      );

      debugPrint("📤 [Floosak] Confirming paymentId=$paymentId with OTP: $otp");

      state = response;

      if (response.isLoaded()) {
        debugPrint("✅ [Floosak] Payment confirmed successfully.");
      } else {
        debugPrint("❌ [Floosak] Payment confirmation failed: ${response.meta.message}");
      }
    } catch (e, s) {
      debugPrint("❌ [Floosak] Exception during confirmation: $e\n$s");
      state = state.setError("Error while confirming Floosak payment: $e");
    }
  }

  /// (اختياري) استرداد
  Future<void> refundFloosakPayment({
    required int paymentId,
    required num amount,
  }) async {
    state = state.setLoading();

    try {
      final response = await request<Payment>(
        url: floosakRefundUrl(paymentId), // إن كان عندك: /api/floosak-payment/{payment}/refund
        method: Method.post,
        body: {'amount': amount},
      );

      debugPrint("📤 [Floosak] Refunding paymentId=$paymentId amount=$amount");

      state = response;

      if (response.isLoaded()) {
        debugPrint("✅ [Floosak] Refund processed successfully.");
      } else {
        debugPrint("❌ [Floosak] Refund failed: ${response.meta.message}");
      }
    } catch (e, s) {
      debugPrint("❌ [Floosak] Exception during refund: $e\n$s");
      state = state.setError("Error while refunding Floosak payment: $e");
    }
  }
}
