import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/logic/filter_model.dart';
import '../../models/response/response.dart';
import '../../models/room_price.dart';
import '../../services/http_service.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'room_prices_provider.g.dart';

//final roomPricesFilterProvider = StateProvider((ref) => const FilterModel());

@Riverpod(keepAlive: false)
class RoomPrices extends _$RoomPrices {
  @override
  Response<List<RoomPrice>> build() =>
      const Response<List<RoomPrice>>(data: []);

  setData(RoomPrice room_price) {
    state = state.copyWith();
  }

  // final x=  HttpService.instance.dio.get('http://192.168.8.142/bookings-guide/public/api/room-prices/1');
  Future fetch({
    required int roomId,
  }) async {
    state = state.setLoading();

    // if (!reset &&
    //     (state.data?.isNotEmpty ?? false) &&
    //     (state.isLoading() || state.isLast())) {
    //   return;
    // }
    //
    // state = state.setLoading();
    // if (reset) {
    //   state = state.copyWith(data: []);
    // }

    try {
      await request<List<dynamic>>(
        url: getRoomPricesUrl(roomId: roomId),
        method: Method.get,
        // body: {
        //   'page': reset ? 1 : (state.meta.currentPage ?? 0) + 1,
        //   if (filter != null) ...filter.toJson(),
        // },
      ).then((value) async {
        List<RoomPrice> roomPrices = RoomPrice.fromJsonList(value.data ?? [])
            .where((room_price) => room_price.roomId == roomId)
            .toList();

        // print("test $value");
        // if (reset) state = state.copyWith(data: []);
        // if (value.isLoaded()) {
        //   state = state.copyWith(
        //       data: reset ? value.data! : [...state.data!, ...value.data!]);
        // }
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
          ? addFacilityUrl()
          : updateFacilityUrl(room_price.id),
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
