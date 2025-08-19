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

  setData(RoomPrice roomPrice) {
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
            .where((roomPrice) => roomPrice.roomId == roomId)
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
}
