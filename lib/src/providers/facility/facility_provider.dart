import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enums/facility_targets.dart';
import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';
import '../favorite/favorite_provider.dart';

export '../../enums/facility_targets.dart';

part 'facility_provider.g.dart';

@Riverpod(keepAlive: false)
class Facilities extends _$Facilities {

  @override
  Response<List<Facility>> build(FacilityTarget target) =>
      Response<List<Facility>>().setLoading();

  Future<void> fetch({
    required int facilityTypeId,
  }) async {

    state = state.setLoading();

    try {
      final url = target == FacilityTarget.maps
          ? getFacilitiesMapUrl(facilityTypeId: facilityTypeId)
          : getFacilitiesUrl(facilityTypeId: facilityTypeId);

      final response = await request<List<dynamic>>(
        url: url,
        method: Method.get,
      );

      final rawList = response.data ?? [];
      List<Facility> facilities = Facility.fromJsonList(rawList);

      if (target == FacilityTarget.favorites) {
        final favoritesState = ref.read(favoritesProvider);
        final favoriteIds =
            favoritesState.data?.map((f) => f.id).toSet() ?? {};

        facilities =
            facilities.where((f) => favoriteIds.contains(f.id)).toList();
      }

      state = Response<List<Facility>>(
        data: facilities,
      ).setLoaded();
      print(state.meta.status);
      print(state.data);

    } catch (e) {
      state = state.setError(e.toString());
    }
  }
}
