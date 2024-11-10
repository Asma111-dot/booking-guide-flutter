import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/room.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'room_provider.g.dart';

@Riverpod(keepAlive: false)
class Rooms extends _$Rooms {
  @override
  Response<List<Room>> build() => const Response<List<Room>>(data: []);

  setData(Room room) {
    state = state.copyWith();
  }

  // Future fetch({required int roomId, required int facilityId}) async {
  //     state = state.setLoading();
  //
  //     final url = getRoomUrl(roomId);
  //
  //     await request<Map<String, dynamic>>(
  //
  //       url: getRoomsUrl(roomId: roomId),
  //       method: Method.get,
  //     ).then((value) async {
  //       List<Room> rooms = Room.fromJsonList((value.data as List<dynamic>?) ?? [])
  //           .where((room) => room.facilityId == facilityId)
  //           .toList();
  //
  //       state = state.copyWith(data: rooms, meta: value.meta);
  //       state = state.setLoaded();
  //     }).catchError((error) {
  //       state = state.setError(error.toString());
  //     });
  Future fetch({int? facilityId}) async {
    if (facilityId != null) {
      state = state.setLoading();

      await request<List<dynamic>>(
        url: getRoomsUrl(facilityId: facilityId), // تم تعديل المعامل هنا
        method: Method.get,
      ).then((value) async {
        List<Room> rooms = Room.fromJsonList(value.data ?? []);

        state = state.copyWith(data: rooms, meta: value.meta);
        state = state.setLoaded();
      }).catchError((error) {
        state = state.setError(error.toString());
      });
    }
  }

  Future save(Room room) async {
    state = state.setLoading();
    await request<Room>(
      url: room.isCreate() ? addRoomUrl() : updateRoomUrl(room.id),
      method: room.isCreate() ? Method.post : Method.put,
      body: room.toJson(),
    ).then((value) async {
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        state = state.copyWith();
        ref.read(roomsProvider.notifier).addOrUpdateRoom(value.data!);
      }
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
