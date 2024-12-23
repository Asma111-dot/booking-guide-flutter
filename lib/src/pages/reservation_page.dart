import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/general_helper.dart';
import '../models/reservation.dart' as res;
import '../models/room_price.dart';
import '../providers/reservation/reservation_save_provider.dart';
import '../utils/routes.dart';
import '../widgets/custom_app_bar.dart';

class ReservationPage extends ConsumerStatefulWidget {
  final RoomPrice roomPrice;

  const ReservationPage({
    Key? key,
    required this.roomPrice,
  }) : super(key: key);

  @override
  ConsumerState<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends ConsumerState<ReservationPage> {
  late TextEditingController adultsController;
  late TextEditingController childrenController;

  @override
  void initState() {
    super.initState();
    adultsController = TextEditingController();
    childrenController = TextEditingController();

    Future.microtask(() {
      final reservation = widget.roomPrice.reservations.first;
      ref.read(formProvider.notifier).updateField(
        roomPriceId: widget.roomPrice.id,
        checkInDate: reservation.checkInDate,
        checkOutDate: reservation.checkOutDate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(formProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: "استكمال الحجز",
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("نوع الحضور:"),
            DropdownButtonFormField<String>(
              value: formState.bookingType.isEmpty || ![
                'Family (Women and Men)',
                'Women Only',
                'Men Only'
              ].contains(formState.bookingType)
                  ? 'Family (Women and Men)'
                  : formState.bookingType,
              items: [
                DropdownMenuItem(
                  value: 'Family (Women and Men)',
                  child: Text('Family (Women and Men)'),
                ),
                DropdownMenuItem(
                  value: 'Women Only',
                  child: Text('Women Only'),
                ),
                DropdownMenuItem(
                  value: 'Men Only',
                  child: Text('Men Only'),
                ),
              ],
              onChanged: (value) {
                ref.read(formProvider.notifier).updateField(bookingType: value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: adultsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "عدد الكبار",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref
                    .read(formProvider.notifier)
                    .updateField(adultsCount: int.tryParse(value));
                print("عدد الكبار: ${int.tryParse(value)}");
              },
            ),
            const SizedBox(height: 30),
            TextField(
              controller: childrenController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "عدد الأطفال",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
               ref
                    .read(formProvider.notifier)
                    .updateField(childrenCount: int.tryParse(value));
                print("عدد الأطفال: ${int.tryParse(value)}");
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("السابق"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("Reservation data being sent:");
                    print("Room price id: ${formState.roomPriceId}");
                    print("In date : ${formState.checkInDate}");
                    print("out date : ${formState.checkOutDate}");
                    print("Booking type : ${formState.bookingType}");
                    print("Adults : ${formState.adultsCount}");
                    print("Children : ${formState.childrenCount}");

                    await ref
                        .read(reservationSaveProvider.notifier)
                        .saveReservation(formState);

                    Navigator.pushNamed(
                      context,
                      Routes.reservationDetails,
                    );
                  },
                  child: const Text("التالي"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
