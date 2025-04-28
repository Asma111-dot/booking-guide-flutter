import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/response/response.dart';
import '../../models/room_price.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'room_prices_provider.g.dart';

@Riverpod(keepAlive: false)
class RoomPrices extends _$RoomPrices {
  @override
  Response<List<RoomPrice>> build() =>
      const Response<List<RoomPrice>>(data: []);

  setData(RoomPrice room_price) {
    state = state.copyWith();
  }

  Future fetch({
    required int roomId,
  }) async {
    state = state.setLoading();

    try {
      await request<List<dynamic>>(
        url: getRoomPricesUrl(roomId: roomId),
        method: Method.get,
      ).then((value) async {
        List<RoomPrice> roomPrices = RoomPrice.fromJsonList(value.data ?? [])
            .where((room_price) => room_price.roomId == roomId)
            .toList();

        state = state.copyWith(data: roomPrices, meta: value.meta);
        state = state.setLoaded();
      }).catchError((error) {
        state = state.setError(error.toString());
        print(error);
      });
    } catch (e, s) {
      print("error test $e");
      print(s);
    }
  }

  Future save(RoomPrice room_price) async {
    state = state.setLoading();
    await request<RoomPrice>(
      url: room_price.isCreate()
          ? addRoomPriceUrl()
          : updateRoomPriceUrl(roomPriceId: room_price.id),

      method: room_price.isCreate() ? Method.post : Method.put,
      body: room_price.toJson(),
    ).then((value) async {
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        addOrUpdateRoomPrice(value.data!);
      }
    }).catchError((error) {
      state = state.setError(error.toString());
    });
  }

  void addOrUpdateRoomPrice(RoomPrice price) {
    if (state.data!.any((e) => e.id == price.id)) {
      var index = state.data!.indexWhere((e) => e.id == price.id);
      state.data![index] = price;
    } else {
      state.data!.add(price);
    }
    state = state.copyWith(data: state.data);
  }
}
//اعمل هانا inti بحيث ينحفظ البيانات لوما اكمل عملية الحجز بشكل كامل
//يوز اقدر اعملها في لارفل داخل الاوث auth بحيث يمررها بشكل تلاقي
