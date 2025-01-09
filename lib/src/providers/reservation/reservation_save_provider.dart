import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';
import 'dart:convert';

part 'reservation_save_provider.g.dart';

@Riverpod(keepAlive: true)
class ReservationSave extends _$ReservationSave {
  @override
  Response<Reservation> build() => Response(data: Reservation.init());

  bool get isLoading => state.meta.isLoading();

  /// Save Reservation Temporarily
  Future saveReservationDraft(Reservation formState) async {
    // Implement temporary save logic
 //   state = state.setLoading();

    final formStateCopy = Reservation.fromJson(
      jsonDecode(jsonEncode(formState.toJson())),
    );

    final reservationDraft = Reservation(
      id: 0,
      roomPriceId: formStateCopy.roomPriceId,
      checkInDate: formStateCopy.checkInDate,
      checkOutDate: formStateCopy.checkOutDate,
      bookingType: formStateCopy.bookingType,
      adultsCount: formStateCopy.adultsCount,
      childrenCount: formStateCopy.childrenCount,
    );
    state = state.copyWith(data: reservationDraft);

    // Debugging
    print("Reservation Draft Created:");
    print("User ID: ${formStateCopy.userId}");
    print("Room Price ID: ${formStateCopy.roomPriceId}");
    print("Check-In Date: ${formStateCopy.checkInDate}");
    print("Check-Out Date: ${formStateCopy.checkOutDate}");
  }

  Future saveReservation(Reservation formState) async {
    state = state.setLoading();
    print("الحالة الحالية: جاري التحميل...");

    await request<Reservation>(
      url: reseravtionSaveUrl(),
      method: Method.post,
      body: await state.data!.toJson(),
    ).then((response) async {
      state = state.copyWith(meta: response.meta);
      print("تم التحميل بنجاح!");
      if (response.isLoaded()) {
        await onSaveSuccess(response);
      }
    }).catchError((error) {
      state = state.setError(error);
      print("حدث خطأ أثناء التحميل: $error");
    });
  }

  Future onSaveSuccess(Response<Reservation> response) async {
    state = state.copyWith(data: response.data);
    print("تم الحفظ بنجاح!");
  }
}
