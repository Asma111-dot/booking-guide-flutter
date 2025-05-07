import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../models/room_price.dart';
import '../providers/reservation/reservation_provider.dart';
import '../providers/reservation/reservation_save_provider.dart';
import '../providers/room_price/room_prices_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_widget.dart';

class ReservationPage extends ConsumerStatefulWidget {
  final RoomPrice roomPrice;

  const ReservationPage({
    super.key,
    required this.roomPrice,
  });

  @override
  ConsumerState<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends ConsumerState<ReservationPage> {
  late TextEditingController adultsController;
  late TextEditingController childrenController;
  final GlobalKey<FormState> reservationKey = GlobalKey<FormState>();
  String? bookingType;

  @override
  void initState() {
    super.initState();
    adultsController = TextEditingController();
    childrenController = TextEditingController();
  }

  @override
  void dispose() {
    adultsController.dispose();
    childrenController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, {bool hasError = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: hasError ? Colors.red : CustomTheme.color2,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CustomTheme.color2, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservation = ref.watch(reservationSaveProvider);
    final roomPriceState = ref.watch(roomPricesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: trans().continueBooking,
        icon: arrowBackIcon,
      ),
      resizeToAvoidBottomInset: true,
      body: ViewWidget<List<RoomPrice>>(
        meta: roomPriceState.meta,
        data: roomPriceState.data,
        refresh: () => ref.read(roomPricesProvider.notifier).fetch(
          roomId: widget.roomPrice.reservations.first.id,
        ),
        forceShowLoaded: roomPriceState.data != null,
        onLoaded: (data) => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Form(
                  key: reservationKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trans().booking_type_hint,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700]),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: bookingType,
                        items: [
                          DropdownMenuItem(
                            value: 'عائلة',
                            child: Text(trans().family),
                          ),
                          DropdownMenuItem(
                            value: 'نساء',
                            child: Text(trans().women),
                          ),
                          DropdownMenuItem(
                            value: 'رجال',
                            child: Text(trans().men),
                          ),
                          DropdownMenuItem(
                            value: 'شركة',
                            child: Text(trans().companies),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            bookingType = value!;
                          });
                        },
                        decoration: _inputDecoration(trans().booking_type),
                        validator: (value) => value == null
                            ? trans().please_choose_booking_type
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.people_alt_outlined,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            trans().adults_hint,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: adultsController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(trans().adults_count),
                        validator: (value) => value!.isEmpty
                            ? trans().please_enter_adults_count
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.child_care_outlined,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            trans().children_hint,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: childrenController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(trans().children_count),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              int.tryParse(value) == null) {}
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Button(
                width: double.infinity,
                title: trans().completeTheReservation,
                icon: const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                iconAfterText: true,
                disable: reservation.isLoading(),
                onPressed: () async {
                  if (reservationKey.currentState!.validate()) {
                    final adultsCount = adultsController.text.isNotEmpty
                        ? int.parse(adultsController.text)
                        : 0;
                    final childrenCount = childrenController.text.isNotEmpty
                        ? int.parse(childrenController.text)
                        : 0;
                    final bookingType = this.bookingType ?? '';

                    if (bookingType.isEmpty || adultsCount == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                trans().please_complete_data_correctly)),
                      );
                      return;
                    }

                    try {
                      await ref
                          .read(reservationSaveProvider.notifier)
                          .saveReservation(
                        reservation.data!,
                        adultsCount: adultsCount,
                        childrenCount: childrenCount,
                        bookingType: bookingType,
                      );

                      final reservationData = reservation.data;
                      await ref.read(reservationProvider.notifier).fetch(
                        roomPriceId: reservationData?.roomPriceId ?? 0,
                      );

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.reservationDetails,
                            (r) => false,
                        arguments: reservationData?.roomPriceId,
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                            Text(trans().error_occurred_during_save)),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(trans().please_complete_data_correctly)),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
