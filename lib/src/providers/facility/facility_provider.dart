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
      const Response<List<Facility>>(data: []);

  setData(Facility facility) {
    state = state.copyWith();
  }

  Future fetch({required int facilityTypeId, int? userId}) async {
    state = state.setLoading();
    String url = getFacilitiesUrl(facilityTypeId: facilityTypeId);


    try {
      await request<List<dynamic>>(
        url: url,
        method: Method.get,
      ).then((value) async {

        List<Facility> facilities = Facility.fromJsonList(value.data ?? []);

        if (target == FacilityTarget.hotels ||
            target == FacilityTarget.chalets) {
          facilities = facilities
              .where((facility) => facility.facilityTypeId == facilityTypeId)
              .toList();
        } else if (target != FacilityTarget.all &&
            target != FacilityTarget.maps) {
          facilities = facilities
              .where((facility) => facility.facilityTypeId == facilityTypeId)
              .toList();
        } else if (target == FacilityTarget.favorites) {
          final favoritesState = ref.read(favoritesProvider);
          final favoriteIds = favoritesState.data?.map((f) => f.id).toSet() ?? {};


          facilities = facilities.where((facility) => favoriteIds.contains(facility.id)).toList();
        } else if (target == FacilityTarget.filters) {
        }

        state = Response<List<Facility>>(data: facilities, meta: value.meta).setLoaded();

        // state = state.copyWith(data: facilities, meta: value.meta);
        // state = state.setLoaded();
      }).catchError((error) {
        state = state.setError(error.toString());
        print("❌ خطأ أثناء جلب البيانات: $error");
      });
    } catch (e, s) {
      print("⚠️ استثناء أثناء الجلب: $e\n$s");
    }
  }
}
