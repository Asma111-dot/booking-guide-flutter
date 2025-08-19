import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/room.dart' as r;
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'room_provider.g.dart';

@Riverpod(keepAlive: false)
class Room extends _$Room {
  @override
  Response<r.Room> build() => const Response<r.Room>();

  setData(r.Room room) {
    state = state.copyWith(data: room);
  }

  void setEmpty() {
    state = state.copyWith(data: null).setLoaded();
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
}

