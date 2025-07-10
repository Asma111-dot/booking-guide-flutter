import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../models/payment.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'payment_jawali_provider.g.dart';

@Riverpod(keepAlive: false)
class PaymentJawali extends _$PaymentJawali {
  @override
  Response<Payment> build() => const Response<Payment>();

  /// ✅ Jawali Payment
  Future<void> payJawali({
    required int reservationId,
    required int paymentMethodId,
    required String voucher,
    required String purpose,
  }) async {
    state = state.setLoading();

    try {
      final response = await request<Payment>(
        url: jawaliPayPaymentUrl(),
        method: Method.post,
        body: {
          'reservation_id': reservationId,
          'payment_method_id': paymentMethodId,
          'voucher': voucher,
          'purpose': purpose,
        },
      );

      debugPrint("📤 [Jawali] Paying for reservation: $reservationId");

      state = response;

      if (response.isLoaded()) {
        debugPrint("✅ [Jawali] Payment successful.");
      } else {
        debugPrint("❌ [Jawali] Payment failed: ${response.meta.message}");
      }
    } catch (error) {
      debugPrint("❌ [Jawali] Exception during payment: $error");
      state = state.setError("Error while processing Jawali payment: $error");
    }
  }
}
