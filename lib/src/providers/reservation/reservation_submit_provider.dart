import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'reservation_submit_provider.g.dart';

@Riverpod(keepAlive: true)
class ReservationSubmitProvider extends _$ReservationSubmitProvider {
  @override
  Response<Reservation> build() => Response(data: Reservation.init());

  Future<void> submit() async {
    state = state.setLoading();
    try {
      final value = await request<Reservation>(
        url: reseravtionSubmitUrl(),
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