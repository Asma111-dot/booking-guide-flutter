import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../models/room_price.dart';
import '../providers/reservation/reservation_provider.dart';
import '../providers/reservation/reservation_save_provider.dart';
import '../providers/room_price/room_prices_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
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

  // bool isLoading = false;

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
      body: ViewWidget<List<RoomPrice>>(
        meta: roomPriceState.meta,
        data: roomPriceState.data,
        refresh: () => ref.read(roomPricesProvider.notifier).fetch(
              roomId: widget.roomPrice.reservations.first.id,
            ),
        forceShowLoaded: roomPriceState.data != null,
        onLoaded: (data) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: reservationKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  decoration: InputDecoration(
                    labelText: trans().booking_type,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ? trans().please_choose_booking_type : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: adultsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: trans().adults_count,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? trans().please_enter_adults_count : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: childrenController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: trans().children_count,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        int.tryParse(value) == null) {}
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                const Spacer(),
                Button(
                  width: double.infinity,
                  title: trans().completeTheReservation,
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: Colors.white,
                  ),
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text(trans().please_complete_data_correctly)));
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
                          SnackBar(content: Text(trans().error_occurred_during_save)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
