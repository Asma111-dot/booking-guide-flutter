import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'facilities_by_type_provider.g.dart';

@riverpod
class FacilitiesByType extends _$FacilitiesByType {
  @override
  Response<List<Facility>> build({required int facilityTypeId}) {
    return const Response<List<Facility>>(data: []);
  }

  Future<void> fetch({int page = 1}) async {
    state = state.setLoading();
    try {
      final res = await request<List<dynamic>>(
        url: getFacilitiesUrl(
          facilityTypeId: facilityTypeId,
          // page: page,
        ),
        method: Method.get,
      );

      final facilities = Facility.fromJsonList(res.data ?? []);
      state = state.copyWith(data: facilities, meta: res.meta);
      state = state.setLoaded();
    } catch (e) {
      state = state.setError(e.toString());
    }
  }
}
