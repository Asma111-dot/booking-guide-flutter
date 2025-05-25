import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/response/response.dart';
import '../../models/payment.dart' as p;
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'payment_provider.g.dart';

@Riverpod(keepAlive: false)
class Payment extends _$Payment {
  @override
  Response<p.Payment> build() =>
      const Response<p.Payment>();

  setData(p.Payment payment) {
    state = state.copyWith(data: payment);
  }

  Future fetch({required int paymentId, p.Payment? payment}) async {
    if (payment != null) {
      state = state.copyWith(data: payment);
      state = state.setLoaded();
      return;
    }

    state = state.setLoading();
    await request<p.Payment>(
      url: getPaymentUrl(paymentId: paymentId),
      method: Method.get,
    ).then((value) async {
      state = state.copyWith(meta: value.meta, data: value.data);
    });
  }

  Future save(p.Payment payment) async {
    state = state.setLoading();
    try {
      final value = await request<p.Payment>(
        url: payment.isCreate() ? addPaymentUrl() : updatePaymentUrl(payment.id),
        method: payment.isCreate() ? Method.post : Method.put,
        body: payment.toJson(),
      );
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        state = state.copyWith(data: value.data);
      }
    } catch (e) {
      state = state.setError();
      print("Error saving room: $e");
    }
  }
}
