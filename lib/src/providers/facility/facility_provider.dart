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
  Response<List<Facility>> build(FacilityTarget target) => const Response<List<Facility>>(data: []);

  setData(Facility facility) {
    state = state.copyWith();
  }
  // setData(Facility facility) {
  //   final updatedList = [...state.data ?? []];
  //   final index = updatedList.indexWhere((e) => e.id == facility.id);
  //   if (index != -1) {
  //     updatedList[index] = facility;
  //   } else {
  //     updatedList.add(facility);
  //   }
  //   state = state.copyWith(data: updatedList);
  // }

  Future fetch({required int facilityTypeId}) async {
    state = state.setLoading();

    try {
      await request<List<dynamic>>(
        url: getFacilitiesUrl(facilityTypeId: facilityTypeId),
        method: Method.get,
      ).then((value) async {
        List<Facility> facilities = Facility.fromJsonList(value.data ?? [])
            .where((facility) => facility.facilityTypeId == facilityTypeId)
            .toList();

        state = state.copyWith(data: facilities, meta: value.meta);
        state = state.setLoaded();
      }).catchError((error) {
        state = state.setError(error.toString());
        print(error);
      });
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Future save(Facility facility) async {
    state = state.setLoading();
    await request<Facility>(
      url: facility.isCreate()
          ? addFacilityUrl()
          : updateFacilityUrl(facility.id),
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
    if (state.data!.any((e) => e.id == facility.id)) {
      var index = state.data!.indexWhere((e) => e.id == facility.id);
      state.data![index] = facility;
    } else {
      state.data!.add(facility);
    }
    state = state.copyWith(data: state.data);
  }
}

// void clearData() {
//   state = state.copyWith(data: [], meta: null);
// }
