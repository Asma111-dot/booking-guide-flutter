import 'package:booking_guide/src/widgets/view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/general_helper.dart';
import '../models/reservation.dart' as res;
import '../models/room_price.dart';
import '../providers/auth/user_provider.dart';
import '../providers/reservation/reservation_save_provider.dart';
import '../providers/room_price/room_prices_provider.dart';
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
  String bookingType = 'Family (Women and Men)';

  @override
  void initState() {
    super.initState();
    adultsController = TextEditingController();
    childrenController = TextEditingController();

    // Future.microtask(() async {
    //   final roomId = widget.roomPrice.reservations.first.id;
    //   final reservation = widget.roomPrice.reservations.first;
    //
    //   await ref.read(roomPricesProvider.notifier).fetch(roomId: roomId);
    //   ref.read(reservationProvider.notifier).fetch(reservationId: roomId);
    //   ref.read(formProvider.notifier).updateField(
    //     roomPriceId: widget.roomPrice.id,
    //     checkInDate: reservation.checkInDate,
    //     checkOutDate: reservation.checkOutDate,
    //     id: reservation.id,
    //     bookingType: reservation.bookingType,
    //     adultsCount: reservation.adultsCount,
    //     childrenCount: reservation.childrenCount,
    //   );
    // });
    Future.microtask(() {
      final reservation = widget.roomPrice.reservations.first;
      ref.read(formProvider.notifier).updateField(
        id: reservation.id,
        roomPriceId: widget.roomPrice.id,
            checkInDate: reservation.checkInDate,
            checkOutDate: reservation.checkOutDate,
          );
    });
  }

  @override
  void dispose() {
    adultsController.dispose();
    childrenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(formProvider);
    final roomPriceState = ref.watch(roomPricesProvider);
    final currentUserId = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: "استكمال الحجز",
        icon: const FaIcon(Icons.arrow_back_ios),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("نوع الحضور:"),
              DropdownButtonFormField<String>(
                value: bookingType,
                items: const [
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
                  // setState(() {
                  //   bookingType = value!;
                  // });
                  ref.read(formProvider.notifier).updateField(bookingType: value, id: 0);
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
                    ref.read(formProvider.notifier).updateField(
                          adultsCount: int.tryParse(value),id: 0);
                    print("عدد الكبار: ${int.tryParse(value)}");
                  }),
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
                        .updateField(childrenCount: int.tryParse(value), id: 0);
                    print("عدد الأطفال: ${int.tryParse(value)}");
                  }),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("السابق"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(reservationSaveProvider.notifier)
                          .saveReservation(formState);

                      Navigator.pushNamed(context, Routes.reservationDetails);
                    },
                    child: const Text("التالي"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

