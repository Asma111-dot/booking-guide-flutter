import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'reservations_provider.g.dart';

@Riverpod(keepAlive: true)
class Reservations extends _$Reservations {
  bool _fetched = false;

  @override
  Response<List<Reservation>> build() {
    return const Response<List<Reservation>>(data: []);
  }

  Future<void> fetch({required int userId, int? facilityId, bool force = false}) async {
    if (_fetched && !force) return; // ⛔ يمنع التكرار

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
        throw Exception("Invalid response format");
      }

      final reservations = Reservation.fromJsonList(reservationsJson);

      state = state.copyWith(data: reservations, meta: response.meta);
      state = state.setLoaded();

      _fetched = true;
    } catch (e, s) {
      state = state.setError(e.toString());
    }
  }

  /// تحديث يدوي (Pull to refresh)
  Future<void> refresh({required int userId, int? facilityId}) async {
    _fetched = false;
    await fetch(userId: userId, facilityId: facilityId, force: true);
  }
}

