import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart' as res;
import '../../models/response/response.dart';
import '../../models/user.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';
import 'reservations_provider.dart';

part 'reservation_provider.g.dart';

@Riverpod(keepAlive: false)
class Reservation extends _$Reservation {
  @override
  Response<res.Reservation> build() =>
      const Response<res.Reservation>();

  setData(res.Reservation reservation) {
    state = state.copyWith(data: reservation);
  }

  Future fetch({required int reservationId ,res.Reservation? reservation}) async {
    if (reservation != null) {
      state = state.copyWith(data: reservation);
      state = state.setLoaded();
      return;
    }

    state = state.setLoading();
    await request<res.Reservation>(
      url: getReservationUrl(reservationId: reservationId),
      method: Method.get,
    ).then((value) async {
      state = state.copyWith(meta: value.meta, data: value.data);
    });
  }

  Future save(res.Reservation reservation) async {
    state = state.setLoading();
    await request<res.Reservation>(
      url: reservation.isCreate()
          ? addReservationUrl()
          : updateReservationUrl(reservation.id),
      method: reservation.isCreate() ? Method.post : Method.put,
      body: reservation.toJson(),
    ).then((value) async {
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        state = state.copyWith(data: value.data);
        ref
            .read(reservationsProvider.notifier)
            .addOrUpdateReservation(value.data!);
      }
    });
  }
}
