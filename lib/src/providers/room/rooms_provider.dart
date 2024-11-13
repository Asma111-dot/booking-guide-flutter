import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/room.dart';
import '../../models/logic/filter_model.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'rooms_provider.g.dart';

final roomsFilterProvider = StateProvider((ref) => const FilterModel());

@Riverpod(keepAlive: false)
class Rooms extends _$Rooms {
  @override
  Response<List<Room>> build() => const Response<List<Room>>(data: []);

  Future fetch({required int facilityId, FilterModel? filter, bool reset = false}) async {
    if (!reset &&
        (state.data?.isNotEmpty ?? false) &&
        (state.isLoading() || state.isLast())) {
      return;
    }

    state = state.setLoading();
    if (reset) {
      state = state.copyWith(data: []);
    }

    await request<List<Room>>(
      url: getRoomsUrl(facilityId: facilityId),
      method: Method.get,
      body: {
        'page': reset ? 1 : (state.meta.currentPage ?? 0) + 1,
        if (filter != null) ...filter.toJson(),
      },
    ).then((value) async {
      if (reset) state = state.copyWith(data: []);
      if (value.isLoaded()) {
        state = state.copyWith(
            data: reset ? value.data! : [...state.data!, ...value.data!]);
      }
      state = state.copyWith(meta: value.meta);
    });
  }

  void addOrUpdateRoom(Room room) {
    if (state.data!.any((e) => e.id == room.id)) {
      var index = state.data!.indexWhere((e) => e.id == room.id);
      state.data![index] = room;
    } else {
      state.data!.add(room);
    }
    state = state.copyWith(data: state.data);
  }
}
