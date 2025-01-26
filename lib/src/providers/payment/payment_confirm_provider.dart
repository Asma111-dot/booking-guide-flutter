import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    state = state.setLoading();
    try {
      final response = await request<Payment>(
        url: confirmPaymentUrl(paymentId),
        method: Method.post,
        body: {'otp': otp},
      );

      if (response.isLoaded()) {
        state = state.copyWith(data: response.data, meta: response.meta);
        print("تم تأكيد الدفع بنجاح مع ID: $paymentId");
      } else {
        print("خطأ أثناء التأكيد في: ${response.meta.message}");
      }
    } catch (error) {
      print("خطأ أثناء التأكيد: $error");
      state = state.setError("خطأ أثناء التأكيد: $error");
    }
  }
}
