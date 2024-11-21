import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/room.dart' as r;
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';
import 'rooms_provider.dart';

part 'room_provider.g.dart';

@Riverpod(keepAlive: false)
class Room extends _$Room {

  @override
  Response<r.Room> build() => const Response<r.Room>();

  setData(r.Room room) {
    state = state.copyWith(data: room);
  }

  Future fetch({required int facilityId, r.Room? room}) async {
    if (room != null) {
      state = state.copyWith(data: room);
      state = state.setLoaded();
      return;
    }

    state = state.setLoading();
    await request<r.Room>(
      url: getRoomUrl(facilityId: facilityId),
      method: Method.get,
    ).then((value) async {
      state = state.copyWith(meta: value.meta, data: value.data);
    });
  }

  Future save(r.Room room) async {
    state = state.setLoading();
    await request<r.Room>(
      url: room.isCreate()
          ? addRoomUrl()
          : updateRoomUrl(roomId: room.id),
      method: room.isCreate() ? Method.post : Method.put,
      body: room.toJson(),
    ).then((value) async {
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        state = state.copyWith(data: value.data);
        ref.read(roomsProvider.notifier).addOrUpdateRoom(value.data!);
      }
    });
  }
}
