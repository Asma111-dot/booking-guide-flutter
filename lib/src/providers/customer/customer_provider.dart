import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/company.dart';
import '../../models/customer.dart' as m;
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';
import 'customers_provider.dart';

part 'customer_provider.g.dart';

@Riverpod(keepAlive: false)
class Customer extends _$Customer {
  @override
  Response<m.Customer> build(Company company, int id) => const Response<m.Customer>();

  setData(m.Customer customer) {
    state = state.copyWith(data: customer);
  }

  Future fetch({m.Customer? customer}) async {
    if(customer != null) {
      state = state.copyWith(data: customer);
      state = state.setLoaded();
      return;
    }

    state = state.setLoading();
    await request<m.Customer>(
      url: getCustomerUrl(company.id.toString(), id),
      method: Method.get,
    ).then((value) async {
      state = state.copyWith(meta: value.meta, data: value.data);
    });
  }

  Future save(m.Customer customer) async {
    state = state.setLoading();
    await request<m.Customer>(
      url: customer.isCreate()
          ? addCustomerUrl(company.id.toString())
          : updateCustomerUrl(company.id.toString(), customer.id),
      method: customer.isCreate() ? Method.post : Method.put,
      body: customer.toJson(),
    ).then((value) async {
      state = state.copyWith(meta: value.meta);
      if(value.isLoaded()) {
        state = state.copyWith( data: value.data);
        ref.read(customersProvider(company).notifier).addOrUpdateCustomer(value.data!);
      }
    });
  }
}