import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/reservation.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'reservations_provider.g.dart';


@Riverpod(keepAlive: false)
class Reservations extends _$Reservations {
  @override
  Response<List<Reservation>> build() =>
      const Response<List<Reservation>>(data: []);

  setData(Reservation reservation) {
    state = state.copyWith();
  }

  Future fetch({required int userId}) async {
    state = state.setLoading();
    try {
      await request<List<dynamic>>(
        url: getReservationsUrl(userId: userId),
        method: Method.get,
      ).then((value) async {
        final reservationsJson = value.data ?? [];

        final reservations = Reservation.fromJsonList(reservationsJson)
            .where((reservation) => reservation.userId == userId)
            .toList();

        state = state.copyWith(data: reservations, meta: value.meta);
        state = state.setLoaded();
      }).catchError((error) {
        print("Error while fetching reservations: $error");
        state = state.setError(error.toString());
      });
    } catch (e, s) {
      print("Unexpected error: $e");
      print("Stacktrace: $s");
    }
  }

  // Future fetch({required int userId}) async {
  //   state = state.setLoading();
  //
  //   try{
  //     await request<List<dynamic>>(
  //       url: getReservationsUrl(userId: userId),
  //       method: Method.get,
  //     ).then((value) async {
  //       List<Reservation> reservations = Reservation.fromJsonList(value.data ?? [])
  //       .where((reservation) => reservation.userId == userId).toList();
  //
  //       state = state.copyWith(data: reservations, meta: value.meta);
  //       state = state.setLoaded();
  //     }).catchError((error) {
  //       state = state.setError(error.toString());
  //       print(error);
  //     });
  //   }catch (e, s) {
  //     print("error test $e");
  //     print(s);
  //   }
  // }

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
