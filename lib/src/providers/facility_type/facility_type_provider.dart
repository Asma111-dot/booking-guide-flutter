import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/facility_type.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'facility_type_provider.g.dart';

@Riverpod(keepAlive: true)
class FacilityTypes extends _$FacilityTypes {
  bool _fetched = false;

  @override
  Response<List<FacilityType>> build() =>
      const Response<List<FacilityType>>(data: []);

  Future<void> fetch({bool force = false}) async {
    if (_fetched && !force) return;

    state = state.setLoading();

    try {
      final response = await request<List<dynamic>>(
        url: getFacilityTypesUrl(),
        method: Method.get,
      );

      final facilityTypes =
      FacilityType.fromJsonList(response.data ?? []);

      state = state.copyWith(data: facilityTypes, meta: response.meta);
      state = state.setLoaded();

      _fetched = true;
    } catch (error) {
      state = state.setError(error.toString());
    }
  }
}

