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

      final value = await request<List<dynamic>>(
        url: getRoomPricesUrl(roomId: roomId),
        method: Method.get,
      );

      final List<RoomPrice> roomPrices =
      RoomPrice.fromJsonList(value.data ?? []);

      state = state.copyWith(
        data: roomPrices,
        meta: value.meta,
      );

      state = state.setLoaded();

    } catch (error) {

      state = state.setError(error.toString());
      print(error);

    }
  }
}
