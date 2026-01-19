import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enums/facility_targets.dart';
import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';
import '../favorite/favorite_provider.dart';

export '../../enums/facility_targets.dart';

part 'facility_provider.g.dart';

@Riverpod(keepAlive: true)
class Facilities extends _$Facilities {
  bool _fetched = false;
  int? _lastFacilityTypeId;

  @override
  Response<List<Facility>> build(FacilityTarget target) =>
      const Response<List<Facility>>(data: []);

  Future<void> fetch({
    required int facilityTypeId,
    bool force = false,
  }) async {
    if (target != FacilityTarget.maps &&
        _fetched &&
        !force &&
        _lastFacilityTypeId == facilityTypeId) {
      return;
    }

    _lastFacilityTypeId = facilityTypeId;
    state = state.setLoading();

    try {
      String url;

      if (target == FacilityTarget.maps) {
        url = getFacilitiesMapUrl(facilityTypeId: facilityTypeId);
      } else {
        url = getFacilitiesUrl(facilityTypeId: facilityTypeId);
      }

      final response = await request<List<dynamic>>(
        url: url,
        method: Method.get,
      );

      List<Facility> facilities = Facility.fromJsonList(response.data ?? []);

      // filter حسب target
      if (target == FacilityTarget.favorites) {
        final favoritesState = ref.read(favoritesProvider);
        final favoriteIds =
            favoritesState.data?.map((f) => f.id).toSet() ?? {};

        facilities =
            facilities.where((f) => favoriteIds.contains(f.id)).toList();
      } else if (target != FacilityTarget.all &&
          target != FacilityTarget.maps) {
        facilities = facilities
            .where((f) => f.facilityTypeId == facilityTypeId)
            .toList();
      }

      state = state.copyWith(data: facilities, meta: response.meta);
      state = state.setLoaded();

      _fetched = true;
    } catch (e) {
      state = state.setError(e.toString());
    }
  }
}
