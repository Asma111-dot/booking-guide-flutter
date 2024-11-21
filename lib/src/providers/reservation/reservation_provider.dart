import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart' as r;
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';
import 'reservations_provider.dart';

part 'reservation_provider.g.dart';

@Riverpod(keepAlive: false)
class Reservation extends _$Reservation {

  @override
  Response<r.Reservation> build() => const Response<r.Reservation>();

  setData(r.Reservation reservation) {
    state = state.copyWith(data: reservation);
  }

  Future fetch({required int userId, r.Reservation? reservation}) async {
    if (reservation != null) {
      state = state.copyWith(data: reservation);
      state = state.setLoaded();
      return;
    }

    state = state.setLoading();
    await request<r.Reservation>(
      url: getReservationUrl(userId: userId),
      method: Method.get,
    ).then((value) async {
      state = state.copyWith(meta: value.meta, data: value.data);
    });
  }

  Future save(r.Reservation reservation) async {
    state = state.setLoading();
    await request<r.Reservation>(
      url: reservation.isCreate()
          ? addReservationUrl()
          : updateReservationUrl(userId: reservation.userId),
      method: reservation.isCreate() ? Method.post : Method.put,
      body: reservation.toJson(),
    ).then((value) async {
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        state = state.copyWith(data: value.data);
        ref.read(reservationsProvider.notifier).addOrUpdateReservation(value.data!);
      }
    });
  }
}