import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../enums/facility_targets.dart';
import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

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

  // setData(Facility facility) {
  //   final updatedList = <Facility>[...(state.data ?? [])];
  //   final index = updatedList.indexWhere((e) => e.id == facility.id);
  //   if (index != -1) {
  //     updatedList[index] = facility;
  //   } else {
  //     updatedList.add(facility);
  //   }
  //   state = state.copyWith(data: updatedList);
  // }
  Future fetch({required int facilityTypeId, int? userId}) async {
    state = state.setLoading();
    print("🔄 Fetching facilities for type: $facilityTypeId");

    String url = getFacilitiesUrl(facilityTypeId: facilityTypeId);

    try {
      await request<List<dynamic>>(
        url: url,
        method: Method.get,
      ).then((value) async {
        List<Facility> facilities = Facility.fromJsonList(value.data ?? []);

        print("📌 Facilities fetched: ${facilities.length}");

        // التأكد من أن التصفية تعتمد على الـ facilityTypeId وليس FacilityTarget
        facilities = facilities.where((facility) => facility.facilityTypeId == facilityTypeId).toList();

        state = state.copyWith(data: facilities, meta: value.meta);
        print("✅ Facilities updated: ${state.data?.length}");

        state = state.setLoaded();
      }).catchError((error) {
        state = state.setError(error.toString());
        print("❌ Error fetching facilities: $error");
      });
    } catch (e, s) {
      print("⚠️ Exception: $e\n$s");
    }
  }

  // Future fetch({required int facilityTypeId, int? userId}) async {
  //     state = state.setLoading();
  //     print("Fetching facilities for type: $facilityTypeId"); // Debug print
  //
  //     String url;
  //     if (target == FacilityTarget.all || target == FacilityTarget.maps) {
  //       url = getFacilitiesUrl();
  //     } else {
  //       url = getFacilitiesUrl(facilityTypeId: facilityTypeId);
  //     }
  //
  //     try {
  //       await request<List<dynamic>>(
  //         url: url,
  //         method: Method.get,
  //       ).then((value) async {
  //         List<Facility> facilities = Facility.fromJsonList(value.data ?? []);
  //         print("Facilities fetched: ${facilities.length}"); // Debug print
  //
  //         if (target == FacilityTarget.hotels || target == FacilityTarget.chalets) {
  //           int typeId = target.facilityTypeId!;
  //           facilities = facilities.where((facility) => facility.facilityTypeId == typeId).toList();
  //         } else if (target != FacilityTarget.all && target != FacilityTarget.maps) {
  //           facilities = facilities.where((facility) => facility.facilityTypeId == facilityTypeId).toList();
  //         }
  //
  //         if (target == FacilityTarget.maps) {
  //           facilities = facilities
  //               .where((facility) =>
  //           facility.latitude != null && facility.longitude != null)
  //               .toList();
  //         }
  //
  //         state = state.copyWith(data: facilities, meta: value.meta);
  //         print("Facilities updated: ${state.data?.length}"); // Debug print
  //
  //         state = state.setLoaded();
  //         print("Facilities state updated"); // Debug print
  //       }).catchError((error) {
  //         state = state.setError(error.toString());
  //         print("Error fetching facilities: $error"); // Debug print
  //       });
  //     } catch (e, s) {
  //       print(e);
  //       print(s);
  //     }
  //   }

    // Future fetch({required int facilityTypeId, int? userId}) async {
  //   state = state.setLoading();
  //
  //   String url;
  //   if (target == FacilityTarget.all || target == FacilityTarget.maps) {
  //     url = getFacilitiesUrl();
  //   } else {
  //     url = getFacilitiesUrl(facilityTypeId: facilityTypeId);
  //   }
  //
  //   try {
  //     await request<List<dynamic>>(
  //       url: url,
  //       method: Method.get,
  //     ).then((value) async {
  //       List<Facility> facilities = Facility.fromJsonList(value.data ?? []);
  //
  //       if (target == FacilityTarget.hotels || target == FacilityTarget.chalets) {
  //         int typeId = target.facilityTypeId!;
  //         facilities = facilities.where((facility) => facility.facilityTypeId == typeId).toList();
  //       } else if (target != FacilityTarget.all && target != FacilityTarget.maps) {
  //         facilities = facilities.where((facility) => facility.facilityTypeId == facilityTypeId).toList();
  //       }
  //
  //       if (target == FacilityTarget.maps) {
  //         facilities = facilities
  //             .where((facility) =>
  //         facility.latitude != null && facility.longitude != null)
  //             .toList();
  //       } else if (target == FacilityTarget.searches) {
  //         // لا شيء هنا؟
  //       }
  //       // else if (target == FacilityTarget.favorites && userId != null) {
  //       //   await fetchFavorites(userId); // جلب قائمة معرفات المفضلات
  //       //   facilities = facilities.where((facility) => favoriteIds.contains(facility.id)).toList();
  //       // }
  //
  //       state = state.copyWith(data: facilities, meta: value.meta);
  //       state = state.setLoaded();
  //     }).catchError((error) {
  //       state = state.setError(error.toString());
  //     });
  //   } catch (e, s) {
  //     print(e);
  //     print(s);
  //   }
  // }

  Future save(Facility facility) async {
    state = state.setLoading();
    await request<Facility>(
      url: facility.isCreate() ? addFacilityUrl() : updateFacilityUrl(facility.id),
      method: facility.isCreate() ? Method.post : Method.put,
      body: facility.toJson(),
    ).then((value) async {
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        addOrUpdateFacility(value.data!);
      }
    }).catchError((error) {
      state = state.setError(error.toString());
    });
  }

  void addOrUpdateFacility(Facility facility) {
    final updatedList = <Facility>[...(state.data ?? [])];
    final index = updatedList.indexWhere((e) => e.id == facility.id);

    if (index != -1) {
      updatedList[index] = facility;
    } else {
      updatedList.add(facility);
    }

    state = state.copyWith(data: updatedList);
  }
}