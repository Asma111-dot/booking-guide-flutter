import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../models/payment.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'payment_cash_provider.g.dart';

@Riverpod(keepAlive: false)
class PaymentCash extends _$PaymentCash {
  @override
  Response<Payment> build() => const Response<Payment>();

  /// ✅ CashPay Payment
  Future<void> payCash({
    required int reservationId,
    required int paymentMethodId,
    required String purpose,
  }) async {
    state = state.setLoading();

    try {
      final response = await request<Payment>(
        url: cashPayPaymentUrl(),
        method: Method.post,
        body: {
          'reservation_id': reservationId,
          'payment_method_id': paymentMethodId,
          'purpose': purpose,
        },
      );

      debugPrint("📤 [CashPay] Paying for reservation: $reservationId");

      state = response;

      if (response.isLoaded()) {
        debugPrint("✅ [CashPay] Payment successful.");
      } else {
        debugPrint("❌ [CashPay] Payment failed: ${response.meta.message}");
      }
    } catch (error) {
      debugPrint("❌ [CashPay] Exception during payment: $error");
      state = state.setError("Error while processing CashPay payment: $error");
    }
  }
}
