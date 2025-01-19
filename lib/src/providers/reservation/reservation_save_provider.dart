import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart' as res;
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/routes.dart';
import '../../utils/urls.dart';
import 'reservation_provider.dart';
import 'dart:convert';

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
    print("User ID: ${formStateCopy.userId}");
    print("Room Price ID: ${formStateCopy.roomPriceId}");
    print("Check-In Date: ${formStateCopy.checkInDate}");
    print("Check-Out Date: ${formStateCopy.checkOutDate}");
  }

  // Future saveReservation(res.Reservation formState, {
  //   required int adultsCount,
  //   required int childrenCount,
  //   required String bookingType,
  // }) async {
  //   state = state.setLoading();
  //   print("الحالة الحالية: جاري التحميل...");
  //
  //   final requestBody = await formState.toJson();
  //   requestBody['adults_count'] = adultsCount;
  //   requestBody['children_count'] = childrenCount;
  //   requestBody['booking_type'] = bookingType;
  //
  //   await request<res.Reservation>(
  //     url: reseravtionSaveUrl(),
  //     method: Method.post,
  //     body: requestBody,
  //   ).then((response) async {
  //     state = state.copyWith(meta: response.meta);
  //     print("تم التحميل بنجاح!");
  //     if (response.isLoaded()) {
  //      await onSaveSuccess(response);
  //     }
  //   }).catchError((error) {
  //     state = state.setError(error);
  //     print("حدث خطأ أثناء التحميل: $error");
  //   });
  // }

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

    await request<res.Reservation>( // ارسال البيانات للخادم
      url: reseravtionSaveUrl(),
      method: Method.post,
      body: requestBody,
    ).then((response) async {
      if (response.data != null) {
        // هنا يجب التأكد من استخدام ID الحجز الذي تم إرجاعه من الخادم
        final reservationData = response.data;

        state = state.copyWith(
          data: reservationData,
        );

        // إضافة إرجاع ID الحجز بعد الحفظ بنجاح
        final reservationId = reservationData?.id;
        print("تم حفظ الحجز بنجاح مع ID: $reservationId");

        // العودة للتفاصيل الخاصة بالحجز
        await ref.read(reservationProvider.notifier).fetch(
          roomPriceId: reservationData?.roomPriceId ?? 0,
        );
        navKey.currentState?.pushNamedAndRemoveUntil(
            Routes.reservationDetails,
        (r) => false,
      //arguments: response.data?.roomPriceId,
        arguments: reservationId,
        // الانتقال إلى صفحة تفاصيل الحجز بعد الحفظ
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   Routes.reservationDetails,  // استخدم المسار المحدد
        //       (r) => false,  // حذف جميع الصفحات السابقة
        //   arguments: reservationId, // تمرير ID الحجز
        );
      }
    }).catchError((error) {
      //state = state.copyWith(meta: Meta.error(message: "حدث خطأ أثناء الحفظ"));
      print("خطأ أثناء الحفظ: $error");
    });
  }


  // Future onSaveSuccess(Response<res.Reservation> response) async {
  //  // state = state.copyWith(data: response.data);
  //   setToken(response.meta.accessToken ?? "");
  //   ref.read(reservationProvider.notifier).saveReservationLocally(response.data!);
  //   navKey.currentState?.pushNamedAndRemoveUntil(Routes.reservationDetails, (r) => false);
  //
  //   print("تم الحفظ بنجاح!");
  // }
  Future onSaveSuccess(Response<res.Reservation> response) async {
    // تحديث الحالة بالبيانات الجديدة
   // setToken(response.meta.accessToken ?? "");
    ref.read(reservationProvider.notifier).saveReservationLocally(response.data!);

    // قم باستدعاء تفاصيل الحجز بعد الحفظ
    await ref.read(reservationProvider.notifier).fetch(
      roomPriceId: response.data?.roomPriceId ?? 0,
    );

    // الانتقال إلى صفحة التفاصيل
    navKey.currentState?.pushNamedAndRemoveUntil(
      Routes.reservationDetails,
          (r) => false,
      arguments: response.data?.roomPriceId, // تمرير ID الحجز
    );

    print("تم الحفظ والانتقال بنجاح!");
  }

}
