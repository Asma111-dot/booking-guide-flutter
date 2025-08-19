import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'reservations_provider.g.dart';

@Riverpod(keepAlive: false)
class Reservations extends _$Reservations {
  List<Map<String, String>> bookedDates = [];

  @override
  Response<List<Reservation>> build() =>
      const Response<List<Reservation>>(data: []);

  setData(Reservation reservation) {
    state = state.copyWith();
  }

  Future fetch({required int userId, int? facilityId}) async {
    state = state.setLoading();

    try {
      final response = await request<dynamic>(
        url: facilityId != null
            ? "${getReservationsUrl()}?facility_id=$facilityId"
            : getReservationsUrl(userId: userId),
        method: Method.get,
      );

      final raw = response.data;
      List<dynamic> reservationsJson;

      if (raw is Map<String, dynamic> && raw['data'] is List) {
        reservationsJson = raw['data'];
      } else if (raw is List) {
        reservationsJson = raw;
      } else {
        throw Exception(
            "Invalid response format: Unable to parse reservations");
      }

      final reservations = Reservation.fromJsonList(reservationsJson)
          .where((reservation) => reservation.userId == userId)
          .toList();

      state = state.copyWith(data: reservations, meta: response.meta);
      state = state.setLoaded();
    } catch (e, s) {
      print("❌ Error while fetching reservations: $e");
      print("📌 Stacktrace: $s");
      state = state.setError(e.toString());
    }
  }
}
