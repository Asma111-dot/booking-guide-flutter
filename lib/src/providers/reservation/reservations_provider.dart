import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/reservation.dart';
import '../../models/logic/filter_model.dart';
import '../../models/response/response.dart';
import '../../models/user.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'reservations_provider.g.dart';

final reservationsFilterProvider = StateProvider((ref) => const FilterModel());

@Riverpod(keepAlive: false)
class Reservations extends _$Reservations {
  @override
  Response<List<Reservation>> build() =>
      const Response<List<Reservation>>(data: []);

  Future fetch({FilterModel? filter, bool reset = false}) async {
    if (!reset &&
        (state.data?.isNotEmpty ?? false) &&
        (state.isLoading() || state.isLast())) {
      return;
    }

    state = state.setLoading();
    if (reset) {
      state = state.copyWith(data: []);
    }

    await request<List<Reservation>>(
      url: getReservationsUrl(),
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

  void addOrUpdateReservation(Reservation reservation) {
    if (state.data!.any((e) => e.id == reservation.id)) {
      var index = state.data!.indexWhere((e) => e.id == reservation.id);
      state.data![index] = reservation;
    } else {
      state.data!.add(reservation);
    }
    state = state.copyWith(data: state.data);
  }
}
