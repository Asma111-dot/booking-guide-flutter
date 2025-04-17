import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/payment.dart' as pay;
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'payment_save_provider.g.dart';

@Riverpod(keepAlive: false)
class PaymentSave extends _$PaymentSave {

  @override
  Response<pay.Payment> build() => const Response<pay.Payment>();

  Future<void> savePayment(pay.Payment payment) async {
    state = state.setLoading();
    try {
      final response = await request<pay.Payment>(
        url: payment.isCreate()
            ? addPaymentUrl()
            : updatePaymentUrl(payment.id),
        method: payment.isCreate() ? Method.post : Method.put,
        body: payment.toJson(),
      );

      if (response.isLoaded()) {
        state = state.copyWith(data: response.data, meta: response.meta);
        print("تم حفظ الدفع بنجاح مع ID: ${response.data?.id}");
      } else {
        print("خطأ أثناء الحفظ: ${response.meta.message}");
      }
    } catch (error) {
      print("خطأ أثناء الحفظ: $error");
      state = state.setError("خطأ أثناء الحفظ: $error");
    }
  }
}
