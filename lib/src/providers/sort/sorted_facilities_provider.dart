import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'sorted_facilities_provider.g.dart';

@Riverpod(keepAlive: true)
class SortedFacilities extends _$SortedFacilities {
  @override
  Response<List<Facility>> build(String sortKey) {
    return const Response<List<Facility>>(data: []);
  }

  Future<void> _fetch(String sortKey) async {
    state = state.setLoading();

    final url = "${searchFacilitiesUrl({})}&sort=$sortKey";

    try {
      final result = await request<Map<String, dynamic>>(
        url: url,
        method: Method.post,
        body: {},
      );

      final List<dynamic> dataList = result.data?['data']?['data'] ?? [];
      final facilities = Facility.fromJsonList(dataList);

      state = state.copyWith(data: facilities, meta: result.meta);
      state = state.setLoaded();
    } catch (error) {
      state = state.setError(error.toString());
    }
  }
}
