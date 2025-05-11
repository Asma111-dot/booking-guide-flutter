import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart' as res;
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'reservation_save_provider.g.dart';

@Riverpod(keepAlive: true)
class ReservationSave extends _$ReservationSave {
  @override
  Response<res.Reservation> build() => Response(data: res.Reservation.init());

  bool get isLoading => state.meta.isLoading();

  /// حفظ الحجز بشكل مؤقت
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

    print("✅ Reservation Draft Created:");
    print("📌 Room Price ID: ${formStateCopy.roomPriceId}");
    print("📆 Check-In Date: ${formStateCopy.checkInDate}");
    print("📆 Check-Out Date: ${formStateCopy.checkOutDate}");
  }

  /// حفظ الحجز بشكل فعلي والانتقال إلى صفحة التفاصيل
  Future<res.Reservation?> saveReservation(
      res.Reservation formState, {
        required int adultsCount,
        required int childrenCount,
        required String bookingType,
      }) async {
    state = state.setLoading();

    final requestBody = await formState.toJson();
    requestBody['adults_count'] = adultsCount;
    requestBody['children_count'] = childrenCount;
    requestBody['booking_type'] = bookingType;
    requestBody['status'] = 'cancelled'; // 👈 نرسلها يدويًا بالحالة الملغاة

    try {
      final response = await request<res.Reservation>(
        url: reservationSaveUrl(),
        method: Method.post,
        body: requestBody,
      );

      if (response.data != null) {
        state = state.copyWith(data: response.data);
        return response.data; // ✅ return the saved reservation
      }
    } catch (error) {
      print("خطأ أثناء الحفظ: $error");
    }

    return null;
  }
}
