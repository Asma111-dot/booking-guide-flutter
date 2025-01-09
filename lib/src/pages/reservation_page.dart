import 'package:booking_guide/src/widgets/view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/general_helper.dart';
import '../models/room_price.dart';
import '../providers/reservation/reservation_save_provider.dart';
import '../providers/room_price/room_prices_provider.dart';
import '../utils/routes.dart';
import '../widgets/button_widget.dart';
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
  final GlobalKey<FormState> reservationKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    adultsController = TextEditingController();
    childrenController = TextEditingController();

    Future.microtask(() {
      final reservation1 = widget.roomPrice.reservations.first;
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
    final reservation = ref.watch(reservationSaveProvider);
    final roomPriceState = ref.watch(roomPricesProvider);

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
              // const Text("نوع الحضور:"),
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
                  print("نوع الحجز الحالي: $value");
                  setState(() {
                    bookingType = value!;
                  });
                },
                // readOnly: reservation.isLoading(),
                decoration: InputDecoration(
                  labelText: "نوع الحجز",
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: adultsController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print("عدد الكبار الحالي: $value");
                  setState(() {});
                },
                // readOnly: reservation.isLoading(),
                decoration: const InputDecoration(
                  labelText: "عدد الكبار",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "الرجاء إدخال عدد الكبار" : null,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: childrenController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print("عدد الأطفال الحالي: $value");
                  setState(() {});
                },
                // readOnly: reservation.isLoading(),
                decoration: const InputDecoration(
                  labelText: "عدد الأطفال",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "الرجاء إدخال عدد الأطفال" : null,
              ),
              const SizedBox(height: 32),

              // ElevatedButton(
              //   onPressed: reservation.isLoading()
              //       ? null
              //       : () async {
              //     if (reservationKey.currentState!.validate()) {
              //       await ref.read(reservationSaveProvider.notifier).saveReservation(
              //         reservation.data!,
              //       );
              //     }
              //   },
              //   child: reservation.isLoading()
              //       ? const CircularProgressIndicator()
              //       : const Text('إتمام الحجز'),
              // ),

              Hero(
                tag: 'reservation',
                child: Button(
                    width: double.infinity,
                    title: trans().completeTheReservation,
                    disable: reservation.isLoading(),
                    onPressed: () async {
                      if (reservationKey.currentState!.validate()) {
                        print(
                            "حالة الحجز قبل الحفظ: ${reservation.isLoading()}");
                        print("بيانات الحجز قبل الحفظ: ${reservation.data}");
                        if (reservation.data != null) {
                          await ref
                              .read(reservationSaveProvider.notifier)
                              .saveReservation(reservation.data!);

                          Navigator.pushNamed(
                              context, Routes.reservationDetails);
                        } else {
                          print("بيانات الحجز غير موجودة.");
                        }
                      } else {
                        print("النموذج غير صالح.");
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
