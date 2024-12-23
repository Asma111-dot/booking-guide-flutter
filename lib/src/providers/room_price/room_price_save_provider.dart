import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../extensions/date_formatting.dart';
import '../../models/response/response.dart';
import '../../models/room_price.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'room_price_save_provider.g.dart';

@Riverpod(keepAlive: true)
class RoomPriceSave extends _$RoomPriceSave {
  @override
  Response<RoomPrice> build() => Response(data: RoomPrice.init());

  Future saveRoomPrice(RoomPrice roomPrice, DateTime dateTime) async {
    state = state.setLoading();

    try {
      final response = await request<RoomPrice>(
        url: reseravtionSaveUrl(),
        method: Method.post,
        body: {
          'room_price_id': roomPrice.id,
          'check_in_date': dateTime.toSql()
        },
      );

      state = state.copyWith(meta: response.meta);

      if (response.isLoaded()) {
        await onSaveSuccess(response);
      } else {
        state = state.setError('حدث خطأ أثناء الحفظ');
      }
    } catch (error) {
      state = state.setError('حدث خطأ: $error');
    }
  }

  Future onSaveSuccess(Response<RoomPrice> response) async {
    state = state.copyWith(data: response.data);
  }
}
