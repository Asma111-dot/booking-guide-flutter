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

  Future fetch({required int roomId, r.Room? room}) async {
    if (room != null) {
      state = state.copyWith(data: room);
      state = state.setLoaded();
      return;
    }

    state = state.setLoading();
    try {
      final value = await request<r.Room>(
        url: getRoomUrl(roomId: roomId),
        method: Method.get,
      );
      state = state.copyWith(meta: value.meta, data: value.data);
    } catch (e) {
      state = state.setError();
      print("Error fetching room: $e");
    }
  }

  Future save(r.Room room) async {
    state = state.setLoading();
    try {
      final value = await request<r.Room>(
        url: room.isCreate()
            ? addRoomUrl()
            : updateRoomUrl(roomId: room.id),
        method: room.isCreate() ? Method.post : Method.put,
        body: room.toJson(),
      );
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        state = state.copyWith(data: value.data);
        ref.read(roomsProvider.notifier).addOrUpdateRoom(value.data!);
      }
    } catch (e) {
      state = state.setError();
      print("Error saving room: $e");
    }
  }
}
