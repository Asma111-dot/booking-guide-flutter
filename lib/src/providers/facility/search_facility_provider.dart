import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'search_facility_provider.g.dart';

@Riverpod(keepAlive: false)
class SearchFacilities extends _$SearchFacilities {
  @override
  Response<List<Facility>> build() {
    return const Response<List<Facility>>(data: []);
  }

  // تنفيذ البحث
  Future search(String query) async {
    state = state.setLoading();  // تعيين الحالة إلى "جار التحميل"
    try {
      await request<List<dynamic>>(
        url: searchFacilitiesUrl(name: query),
        method: Method.get,
      ).then((value) async {
        List<Facility> facilities = Facility.fromJsonList(value.data ?? []);

        state = state.copyWith(data: facilities, meta: value.meta);
        state = state.setLoaded();  // تعيين الحالة إلى "تم التحميل"
      }).catchError((error) {
        state = state.setError(error.toString());
        print(error);
      });
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
