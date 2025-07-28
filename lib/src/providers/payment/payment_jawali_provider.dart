import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/payment.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'payment_jawali_provider.g.dart';

@Riverpod(keepAlive: false)
class PaymentJawali extends _$PaymentJawali {
  @override
  Response<Payment> build() => const Response<Payment>();

  /// ✅ Step 1: Initiate Jawali Payment
  Future<void> initiateJawaliPayment(int reservationId) async {
    state = state.setLoading();

    try {
      final response = await request<Payment>(
        url: jawaliInitiatePaymentUrl(),
        method: Method.post,
        body: {
          'reservation_id': reservationId,
        },
      );

      debugPrint("📤 [Jawali] Initiating payment for reservation: $reservationId");

      state = response;

      if (response.isLoaded()) {
        debugPrint("✅ [Jawali] Payment initiation successful.");
      } else {
        debugPrint("❌ [Jawali] Payment initiation failed: ${response.meta.message}");
      }
    } catch (error) {
      debugPrint("❌ [Jawali] Exception during initiation: $error");
      state = state.setError("Error while initiating Jawali payment: $error");
    }
  }

  /// ✅ Step 2: Confirm Jawali Payment with Code
  Future<void> confirmJawaliPayment({
    required int reservationId,
    required int paymentMethodId,
    required String code,
  }) async {
    state = state.setLoading();

    try {
      final response = await request<Payment>(
        url: jawaliConfirmPaymentUrl(),
        method: Method.post,
        body: {
          'reservation_id': reservationId,
          'payment_method_id': paymentMethodId,
          'code': code,
        },
      );

      debugPrint("📤 [Jawali] Confirming payment with code: $code for reservation: $reservationId");

      state = response;

      if (response.isLoaded()) {
        debugPrint("✅ [Jawali] Payment confirmed successfully.");
      } else {
        debugPrint("❌ [Jawali] Payment confirmation failed: ${response.meta.message}");
      }
    } catch (error) {
      debugPrint("❌ [Jawali] Exception during confirmation: $error");
      state = state.setError("Error while confirming Jawali payment: $error");
    }
  }
}
