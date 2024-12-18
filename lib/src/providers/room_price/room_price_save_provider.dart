import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/response/response.dart';
import '../../models/room_price.dart' ;
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'room_price_save_provider.g.dart';

@Riverpod(keepAlive: true)
class RoomPriceSaveProvider extends _$RoomPriceSaveProvider {
  @override
  Response<RoomPrice> build() => Response(data: RoomPrice.init());

  Future<void> saveRoomPrice() async {
    state = state.setLoading();
    await request<RoomPrice>(
      url: roomPriceSaveUrl(),
      method: Method.post,
      body: await state.data!.toJson(),
    ).then((response) async {
      state = state.copyWith(meta: response.meta);
      if (response.isLoaded()) {
        await onSaveSuccess(response);
      }
    }).catchError((error) {
      state = state.setError(error);
    });
  }

  Future<void> onSaveSuccess(Response<RoomPrice> response) async {
    state = state.copyWith(data: response.data);
  }
}
