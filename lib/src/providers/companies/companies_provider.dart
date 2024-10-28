import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/company.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';

part 'companies_provider.g.dart';

@Riverpod(keepAlive: true)
class Companies extends _$Companies {
  @override
  Response<List<Company>> build() => const Response<List<Company>>();

  Future fetch() async {
    state = state.setLoading();
    await request<List<Company>>(
      url: 'url here',
      method: Method.get,
    ).then((value) async {
      state = state.copyWith(data: value.data, meta: value.meta);
    });
  }

  saveCompanies(List<Company> companies) {
    state = state.copyWith(data: companies);
    if(companies.isNotEmpty) {
      state = state.setLoaded();
      selectCompany(companies.first.id);
    }
    else {
      state = state.setEmpty();
    }
  }

  selectCompany(int id) {
    var index = state.data!.indexWhere((e) => id == e.id);
    for (var e in state.data!) {
      e.selected = false;
    }
    if(index >= 0) state.data![index].selected = true;
    state = state.copyWith(data: state.data);
  }

  Company? currentCompany() => state.data?.firstOrNull;
}