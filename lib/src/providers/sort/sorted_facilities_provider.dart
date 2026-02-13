import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'sorted_facilities_provider.g.dart';

@riverpod
class SortedFacilities extends _$SortedFacilities {
  @override
  Response<List<Facility>> build(String sortKey) {
    Future.microtask(() => fetchSortedFacilities());
    return const Response<List<Facility>>(data: []);
  }

  Future<void> fetchSortedFacilities([String? customSortKey]) async {
    final key = customSortKey ?? sortKey;

    state = state.setLoading();

    try {
      final result = await request<List<dynamic>>(
        url: searchFacilitiesUrl({
          "sort": key,
        }),
        method: Method.get,
      );

      final List<dynamic> dataList = result.data ?? [];
      final facilities = Facility.fromJsonList(dataList);
      print("Fetched facilities count: ${facilities.length}");

      state = Response<List<Facility>>(
        data: facilities,
        meta: result.meta,
      ).setLoaded();
    } catch (error) {
      state = state.setError(error.toString());
    }
  }
}
