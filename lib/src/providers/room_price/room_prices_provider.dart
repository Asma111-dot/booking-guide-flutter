import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/logic/filter_model.dart';
import '../../models/response/response.dart';
import '../../models/room_price.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'room_prices_provider.g.dart';

final roomPricesFilterProvider = StateProvider((ref) => const FilterModel());

@Riverpod(keepAlive: false)
class RoomPrices extends _$RoomPrices {
  @override
  Response<List<RoomPrice>> build() =>
      const Response<List<RoomPrice>>(data: []);

  Future fetch(
      {required int roomPriceId, FilterModel? filter, bool reset = false}) async {
    if (!reset &&
        (state.data?.isNotEmpty ?? false) &&
        (state.isLoading() || state.isLast())) {
      return;
    }

    state = state.setLoading();
    if (reset) {
      state = state.copyWith(data: []);
    }

    await request<List<RoomPrice>>(
      url: getRoomPricesUrl(roomPriceId: roomPriceId),
      method: Method.get,
      body: {
        'page': reset ? 1 : (state.meta.currentPage ?? 0) + 1,
        if (filter != null) ...filter.toJson(),
      },
    ).then((value) async {
      if (reset) state = state.copyWith(data: []);
      if (value.isLoaded()) {
        state = state.copyWith(
            data: reset ? value.data! : [...state.data!, ...value.data!]);
      }
      state = state.copyWith(meta: value.meta);
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
