import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'filtered_facilities_provider.g.dart';

@Riverpod(keepAlive: true)
class FilteredFacilities extends _$FilteredFacilities {
  @override
  Response<List<Facility>> build(Map<String, String> filters) =>
      const Response<List<Facility>>(data: []);

  Future<void> fetch() async {
    state = state.setLoading();

    final currentFilters = this.filters;

    final result = await request<Map<String, dynamic>>(
      url: searchFacilitiesUrl(currentFilters),
      method: Method.get,   // 🔥 تغيير مهم
      body: null,           // 🔥 لا نرسل body
    );

    final facilities =
    Facility.fromJsonList(result.data?['data'] ?? []);

    state = state.copyWith(data: facilities, meta: result.meta);
    state = state.setLoaded();
  }
}
