import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'reservation_save_provider.g.dart';

@Riverpod(keepAlive: true)
class ReservationSaveProvider extends _$ReservationSaveProvider {
  @override
  Response<Reservation> build() => Response(data: Reservation.init());

  Future<void> saveReservation() async {
    state = state.setLoading();
    await request<Reservation>(
      url: reseravtionSaveUrl(),
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

  Future<void> onSaveSuccess(Response<Reservation> response) async {
    state = state.copyWith(data: response.data);
  }
}
