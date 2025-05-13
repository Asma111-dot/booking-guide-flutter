import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'reservations_provider.g.dart';

@Riverpod(keepAlive: false)
class Reservations extends _$Reservations {
  List<String> bookedDates = [];

  @override
  Response<List<Reservation>> build() =>
      const Response<List<Reservation>>(data: []);

  setData(Reservation reservation) {
    state = state.copyWith();
  }

  Future<void> fetchBookedDates(int facilityId) async {
    state = state.setLoading();

    try {
      final response = await request<List<String>>(
        url: getBookedDatesUrl(facilityId),
        method: Method.get,
        key: 'dates',
      );

      bookedDates = response.data ?? [];
      print("📅 التواريخ المحجوزة: $bookedDates");

      state = state.setLoaded();
    } catch (e, s) {
      print("❌ Error fetching booked dates from Google Calendar: $e");
      print("📌 Stacktrace: $s");
      state = state.setError(e.toString());
    }
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
        throw Exception("Invalid response format: Unable to parse reservations");
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

  Future save(Reservation reservation) async {
    state = state.setLoading();
    await request<Reservation>(
      url: reservation.isCreate()
          ? addReservationUrl()
          : updateReservationUrl(reservation.id),
      method: reservation.isCreate() ? Method.post : Method.put,
      body: reservation.toJson(),
    ).then((value) async {
      state = state.copyWith(meta: value.meta);
      if (value.isLoaded()) {
        addOrUpdateReservation(value.data!);
      }
    }).catchError((error) {
      state = state.setError(error.toString());
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
