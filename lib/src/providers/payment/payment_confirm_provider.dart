import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart'; // for debugPrint

import '../../helpers/notify_helper.dart';
import '../../models/payment.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'payment_confirm_provider.g.dart';

@Riverpod(keepAlive: false)
class PaymentConfirm extends _$PaymentConfirm {
  @override
  Response<Payment> build() => const Response<Payment>();

  Future<void> confirmPayment(int paymentId, int otp) async {
    state = state.setLoading(); // 🔄 تغيير الحالة إلى Loading

    try {
      final response = await request<Payment>(
        url: confirmPaymentUrl(paymentId),
        method: Method.post,
        body: {'otp': otp},
      );

      debugPrint("📤 Sending confirmation request to: ${confirmPaymentUrl(paymentId)}");
      debugPrint("📦 Payload: {otp: $otp}");

      state = response; // ✅ تحديث الحالة مهما كانت

      if (response.isLoaded()) {
        debugPrint("✅ Payment confirmed successfully for ID: $paymentId");

        if (response.meta.message.trim().isNotEmpty) {
          showNotify(
            message: response.meta.message,
            alert: Alert.success,
          );
        }

        // ✅ التنقل مسؤولية الـ UI فقط، وهذا ممتاز
        // navKey.currentState?.pushNamedAndRemoveUntil(...)
      } else {
        debugPrint("❌ Failed to confirm payment. Message: ${response.meta.message}");
      }
    } catch (error) {
      debugPrint("❌ Exception during confirmation: $error");
      state = state.setError("Error while confirming payment: $error");
    }
  }
}
