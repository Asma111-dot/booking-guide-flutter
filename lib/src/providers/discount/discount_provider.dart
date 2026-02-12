import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/discount.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'discount_provider.g.dart';

@Riverpod(keepAlive: false)
class Discounts extends _$Discounts {
  @override
  Response<List<Discount>> build() => const Response<List<Discount>>(data: []);

  Future fetch({int? discountId}) async {
    state = state.setLoading();

    String url = discountId != null ? getDiscountUrl(discountId) : getDiscountsUrl();

    try {
      await request<List<dynamic>>(
        url: url,
        method: Method.get,
      ).then((value) {
        List<Discount> discounts = value.data != null
            ? List<Discount>.from(value.data!.map((d) => Discount.fromJson(d)))
            : [];

        state = Response<List<Discount>>(data: discounts, meta: value.meta).setLoaded();
      }).catchError((error) {
        state = state.setError(error.toString());
        print("❌ خطأ أثناء جلب الخصومات: $error");
      });
    } catch (e, s) {
      print("⚠️ استثناء أثناء جلب الخصومات: $e\n$s");
      state = state.setError(e.toString());
    }
  }
}
