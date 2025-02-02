import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart' as res;
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/routes.dart';
import '../../utils/urls.dart';

part 'reservation_save_provider.g.dart';

@Riverpod(keepAlive: true)
class ReservationSave extends _$ReservationSave {
  @override
  Response<res.Reservation> build() => Response(data: res.Reservation.init());

  bool get isLoading => state.meta.isLoading();

  /// Save Reservation Temporarily
  Future saveReservationDraft(res.Reservation formState) async {
    final formStateCopy = res.Reservation.fromJson(
      jsonDecode(jsonEncode(formState.toJson())),
    );

    final reservationDraft = res.Reservation(
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
    print("Room Price ID: ${formStateCopy.roomPriceId}");
    print("Check-In Date: ${formStateCopy.checkInDate}");
    print("Check-Out Date: ${formStateCopy.checkOutDate}");
  }

  /// Save Reservation and Navigate to Details
  Future saveReservation(res.Reservation formState, {
    required int adultsCount,
    required int childrenCount,
    required String bookingType,
  }) async {
    state = state.setLoading();
    print("الحالة الحالية: جاري التحميل...");

    final requestBody = await formState.toJson();
    requestBody['adults_count'] = adultsCount;
    requestBody['children_count'] = childrenCount;
    requestBody['booking_type'] = bookingType;

    try {
      final response = await request<res.Reservation>(
        url: reservationSaveUrl(),
        method: Method.post,
        body: requestBody,
      );

      if (response.data != null) {
        final reservationData = response.data;
        state = state.copyWith(data: reservationData);

        final reservationId = reservationData?.id;
        print("تم حفظ الحجز بنجاح مع ID: $reservationId");

        // // Fetch reservation details
        // await ref.read(reservationProvider.notifier).fetch(
        //   roomPriceId: reservationData?.roomPriceId ?? 0,
        // );

        // Navigate to reservation details page
        navKey.currentState?.pushNamedAndRemoveUntil(
          Routes.reservationDetails,
              (r) => false,
          arguments: reservationId,
        );
      }
    } catch (error) {
      print("خطأ أثناء الحفظ: $error");
    }
  }

  /// Handle Save Success
  // Future onSaveSuccess(Response<res.Reservation> response) async {
  //   ref.read(reservationProvider.notifier).saveReservationLocally(response.data!);
  //
  //   await ref.read(reservationProvider.notifier).fetch(
  //     roomPriceId: response.data?.roomPriceId ?? 0,
  //   );
  //
  //   navKey.currentState?.pushNamedAndRemoveUntil(
  //     Routes.reservationDetails,
  //         (r) => false,
  //     arguments: response.data?.roomPriceId,
  //   );
  //
  //   print("تم الحفظ والانتقال بنجاح!");
  // }
}
