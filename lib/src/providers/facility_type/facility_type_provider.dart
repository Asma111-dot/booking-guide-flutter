import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/facility_type.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'facility_type_provider.g.dart';

@Riverpod(keepAlive: false)
class FacilityTypes extends _$FacilityTypes {
  @override
  Response<List<FacilityType>> build() =>
      const Response<List<FacilityType>>(data: []);

  setData(FacilityType facilityType) {
    state = state.copyWith();
  }

  Future fetch({FacilityType? facilityType}) async {
    if (facilityType != null) {
      state = state.copyWith();
      state = state.setLoaded();
      return;
    }

    state = state.setLoading();

    await request<List<dynamic>>(
      url: getFacilityTypesUrl(),
      method: Method.get,
    ).then((value) async {
      List<FacilityType> facilityTypes =
          FacilityType.fromJsonList(value.data ?? []);

      state = state.copyWith(data: facilityTypes, meta: value.meta);
      state = state.setLoaded();
    }).catchError((error) {
      state = state.setError(error.toString());
    });
  }

  Future save(FacilityType facilityType) async {
    state = state.setLoading();
    await request<FacilityType>(
      url: facilityType.isCreate()
          ? addFacilityTypeUrl()
          : updateFacilityTypeUrl(facilityType.id),
      method: facilityType.isCreate() ? Method.post : Method.put,
      body: facilityType.toJson(),
    ).then((value) async {
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        state = state.copyWith();
        ref
            .read(facilityTypesProvider.notifier)
            .addOrUpdateFacilityType(value.data!);
      }
    });
  }

  void addOrUpdateFacilityType(FacilityType facilityType) {
    if (state.data!.any((e) => e.id == facilityType.id)) {
      var index = state.data!.indexWhere((e) => e.id == facilityType.id);
      state.data![index] = facilityType;
    } else {
      state.data!.add(facilityType);
    }
    state = state.copyWith(data: state.data);
  }
}
