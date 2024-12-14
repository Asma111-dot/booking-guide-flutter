import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/response/response.dart';
import '../../models/room_price.dart' as p;
import '../../services/request_service.dart';
import '../../utils/urls.dart';
import 'room_prices_provider.dart';

part 'room_price_provider.g.dart';

// RoomPriceSubmit: إدارة إرسال بيانات السعر
@Riverpod(keepAlive: true)
class RoomPriceSubmit extends _$RoomPriceSubmit {
  @override
  Response<p.RoomPrice> build() => Response(data: p.RoomPrice.init());

  Future<void> submit() async {
    state = state.setLoading();
    try {
      final value = await request<p.RoomPrice>(
        url: roomPriceSubmitUrl(),
        method: Method.post,
        body: await state.data!.toJson(),
      );
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        state = state.copyWith(data: value.data);
      }
    } catch (e) {
      state = state.setError();
      print("Error submitting room price: $e");
    }
  }
}

// RoomPrice: إدارة استرجاع وتحديث بيانات السعر
@Riverpod(keepAlive: false)
class RoomPrice extends _$RoomPrice {
  Response<p.RoomPrice> build() => const Response<p.RoomPrice>();

  void setData(p.RoomPrice price) {
    state = state.copyWith(data: price);
  }

  Future<void> fetch({required int roomPriceId, p.RoomPrice? price}) async {
    if (price != null) {
      state = state.copyWith(data: price);
      state = state.setLoaded();
      return;
    }

    state = state.setLoading();
    try {
      final value = await request<p.RoomPrice>(
        url: getRoomPriceUrl(roomPriceId: roomPriceId),
        method: Method.get,
      );
      state = state.copyWith(meta: value.meta, data: value.data);
    } catch (e) {
      state = state.setError();
      print("Error fetching room price: $e");
    }
  }

  Future<void> save(p.RoomPrice price) async {
    state = state.setLoading();
    try {
      final value = await request<p.RoomPrice>(
        url: price.isCreate() ? addRoomPriceUrl() : updateRoomPriceUrl(roomPriceId: price.id),
        method: price.isCreate() ? Method.post : Method.put,
        body: price.toJson(),
      );
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        state = state.copyWith(data: value.data);
        ref.read(roomPricesProvider.notifier).addOrUpdateRoomPrice(value.data!);
      }
    } catch (e) {
      state = state.setError();
      print("Error saving room price: $e");
    }
  }
}

