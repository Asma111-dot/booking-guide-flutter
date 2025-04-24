import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'filtered_facilities_provider.g.dart';

// @riverpod
@Riverpod(keepAlive: true)
class FilteredFacilities extends _$FilteredFacilities {
  @override
  Response<List<Facility>> build(Map<String, String> filters) =>
      const Response<List<Facility>>(data: []);

  Future<void> fetch() async {
    state = state.setLoading();

    final url = searchFacilitiesUrl(this.filters);

    try {
      final result = await request<List<dynamic>>(
        url: url,
        method: Method.post,
        body: filters,        // ✅ filters هو Map<String, String>
      );

      final facilities = Facility.fromJsonList(result.data ?? []);

      state = state.copyWith(data: facilities, meta: result.meta);
      state = state.setLoaded();
    } catch (error) {
      state = state.setError(error.toString());
    }
  }
}
