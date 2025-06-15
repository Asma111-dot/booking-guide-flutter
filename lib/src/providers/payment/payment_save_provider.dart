import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart'; // for debugPrint

import '../../models/payment.dart' as pay;
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'payment_save_provider.g.dart';

@Riverpod(keepAlive: true)
class PaymentSave extends _$PaymentSave {

  @override
  Response<pay.Payment> build() => const Response<pay.Payment>();

  Future<void> savePayment(pay.Payment payment) async {
    state = state.setLoading();

    final url = payment.isCreate()
        ? addPaymentUrl()
        : updatePaymentUrl(payment.id);
    final method = payment.isCreate() ? Method.post : Method.put;
    final payload = payment.isCreate()
        ? payment.toJsonForCreate()
        : payment.toJson();

    debugPrint("📤 [PaymentSave] Sending request:");
    debugPrint("→ URL: $url");
    debugPrint("→ Method: ${method.name}");
    debugPrint("→ Payload: $payload");

    try {
      final response = await request<pay.Payment>(
        url: url,
        method: method,
        body: payload,
      );

      if (response.isLoaded()) {
        state = state.copyWith(data: response.data, meta: response.meta);
        debugPrint("✅ [PaymentSave] Payment saved successfully. ID: ${response.data?.id}");
      } else {
        debugPrint("⚠️ [PaymentSave] Server responded with error: ${response.meta.message}");
        state = state.copyWith(meta: response.meta);
      }
    } catch (error, stack) {
      debugPrint("❌ [PaymentSave] Exception while saving payment: $error");
      debugPrint("🪵 Stack Trace:\n$stack");
      state = state.setError("Error while saving payment: $error");
    }
  }
}
