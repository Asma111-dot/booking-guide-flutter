import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/company.dart';
import '../../models/customer.dart';
import '../../models/logic/filter_model.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'customers_provider.g.dart';

final customersFilterProvider = StateProvider((ref) => const FilterModel());

@Riverpod(keepAlive: false)
class Customers extends _$Customers {
  @override
  Response<List<Customer>> build(Company company) =>
      const Response<List<Customer>>(data: []);

  Future fetch({FilterModel? filter, bool reset = false}) async {
    if (!reset &&
        (state.data?.isNotEmpty ?? false) &&
        (state.isLoading() || state.isLast())) {
      return;
    }

    state = state.setLoading();
    if (reset) {
      state = state.copyWith(data: []);
    }

    await request<List<Customer>>(
      url: getCustomersUrl(company.id.toString()),
      method: Method.get,
      body: {
        'page': reset ? 1 : (state.meta.currentPage ?? 0) + 1,
        if (filter != null) ...filter.toJson(),
      },
    ).then((value) async {
      if (reset) state = state.copyWith(data: []);
      if (value.isLoaded()) {
        state = state.copyWith(
            data: reset ? value.data! : [...state.data!, ...value.data!]);
      }
      state = state.copyWith(meta: value.meta);
    });
  }

  void addOrUpdateCustomer(Customer customer) {
    if (state.data!.any((e) => e.id == customer.id)) {
      var index = state.data!.indexWhere((e) => e.id == customer.id);
      state.data![index] = customer;
    } else {
      state.data!.add(customer);
    }
    state = state.copyWith(data: state.data);
  }
}
