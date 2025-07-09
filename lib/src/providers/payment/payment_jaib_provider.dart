import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../models/payment.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'payment_jaib_provider.g.dart';

@Riverpod(keepAlive: false)
class PaymentJaib extends _$PaymentJaib {
  @override
  Response<Payment> build() => const Response<Payment>();

  /// ✅ Step 1: Initiate Jaib Payment
  Future<void> initiateJaibPayment(int reservationId) async {
    state = state.setLoading();

    try {
      final response = await request<Payment>(
        url: jaibInitiatePaymentUrl(),
        method: Method.post,
        body: {
          'reservation_id': reservationId,
        },
      );

      debugPrint("📤 [Jaib] Initiating payment for reservation: $reservationId");

      state = response;

      if (response.isLoaded()) {
        debugPrint("✅ [Jaib] Payment initiation successful.");
      } else {
        debugPrint("❌ [Jaib] Payment initiation failed: ${response.meta.message}");
      }
    } catch (error) {
      debugPrint("❌ [Jaib] Exception during initiation: $error");
      state = state.setError("Error while initiating Jaib payment: $error");
    }
  }

  /// ✅ Step 2: Confirm Jaib Payment with Code
  Future<void> confirmJaibPayment({
    required int reservationId,
    required int paymentMethodId,
    required String code,
  }) async {
    state = state.setLoading();

    try {
      final response = await request<Payment>(
        url: jaibConfirmPaymentUrl(),
        method: Method.post,
        body: {
          'reservation_id': reservationId,
          'payment_method_id': paymentMethodId,
          'code': code,
        },
      );

      debugPrint("📤 [Jaib] Confirming payment with code: $code for reservation: $reservationId");

      state = response;

      if (response.isLoaded()) {
        debugPrint("✅ [Jaib] Payment confirmed successfully.");
      } else {
        debugPrint("❌ [Jaib] Payment confirmation failed: ${response.meta.message}");
      }
    } catch (error) {
      debugPrint("❌ [Jaib] Exception during confirmation: $error");
      state = state.setError("Error while confirming Jaib payment: $error");
    }
  }
}
