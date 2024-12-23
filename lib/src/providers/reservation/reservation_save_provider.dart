import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/reservation.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'reservation_save_provider.g.dart';

/// Form Notifier to handle form state
class FormNotifier extends StateNotifier<Reservation> {
  FormNotifier()
      : super(Reservation(
          id: 0,
          checkInDate: DateTime.now(),
          checkOutDate: DateTime.now(),
          bookingType: '',
        ));

  void updateField({
    int? userId,
    int? roomPriceId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    String? status,
    String? bookingType,
    int? adultsCount,
    int? childrenCount,
  }) {
    state = state.copyWith(
      userId: userId,
      roomPriceId: roomPriceId,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      status: status,
      bookingType: bookingType,
      adultsCount: adultsCount,
      childrenCount: childrenCount,
    );
  }
}

/// Reservation Save Provider
final formProvider = StateNotifierProvider<FormNotifier, Reservation>(
  (ref) => FormNotifier(),
);

@Riverpod(keepAlive: true)
class ReservationSave extends _$ReservationSave {
  @override
  Response<Reservation> build() => Response(data: Reservation.init());

  /// Save Reservation Temporarily
  Future<void> saveReservationDraft(Reservation formState) async {
    // Implement temporary save logic
    state = state.setLoading();
    final reservationDraft = Reservation(
      id: 0,
      userId: formState.userId,
      roomPriceId: formState.roomPriceId,
      checkInDate: formState.checkInDate,
      checkOutDate: formState.checkOutDate,
      status: formState.status,
      totalPrice: 0.0,
      bookingType: formState.bookingType,
      adultsCount: formState.adultsCount,
      childrenCount: formState.childrenCount,
      payments: [],
    );
    state = state.copyWith(data: reservationDraft);
  }

  /// Save Reservation Permanently
  Future<void> saveReservation(Reservation formState) async {
    state = state.setLoading();
    final reservationData = Reservation(
      id: 0,
      userId: formState.userId,
      roomPriceId: formState.roomPriceId,
      checkInDate: formState.checkInDate,
      checkOutDate: formState.checkOutDate,
      status: formState.status,
      totalPrice: 0.0,
      bookingType: formState.bookingType,
      adultsCount: formState.adultsCount,
      childrenCount: formState.childrenCount,
      payments: [],
    );
    // Future<void> saveReservation(FormState formState) async {
    //   state = state.setLoading();
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
