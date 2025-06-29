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

  Future save(Discount discount) async {
    state = state.setLoading();
    await request<Discount>(
      url: discount.id == 0 ? addDiscountUrl() : updateDiscountUrl(discount.id),
      method: discount.id == 0 ? Method.post : Method.put,
      body: discount.toJson(),
    ).then((value) {
      if (value.isLoaded()) {
        addOrUpdateDiscount(value.data!);
      }
      state = state.copyWith(meta: value.meta).setLoaded();
    }).catchError((error) {
      state = state.setError(error.toString());
    });
  }

  Future delete(int discountId) async {
    state = state.setLoading();
    await request(
      url: deleteDiscountUrl(discountId),
      method: Method.delete,
    ).then((value) {
      final updatedList = <Discount>[...(state.data ?? [])]..removeWhere((d) => d.id == discountId);
      state = state.copyWith(data: updatedList, meta: value.meta).setLoaded();
    }).catchError((error) {
      state = state.setError(error.toString());
    });
  }

  void addOrUpdateDiscount(Discount discount) {
    final updatedList = <Discount>[...(state.data ?? [])];
    final index = updatedList.indexWhere((d) => d.id == discount.id);

    if (index != -1) {
      updatedList[index] = discount;
    } else {
      updatedList.add(discount);
    }

    state = state.copyWith(data: updatedList);
  }
}
