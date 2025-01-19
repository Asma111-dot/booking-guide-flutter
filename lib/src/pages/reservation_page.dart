import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/general_helper.dart';
import '../models/room_price.dart';
import '../providers/reservation/reservation_provider.dart';
import '../providers/reservation/reservation_save_provider.dart';
import '../providers/room_price/room_prices_provider.dart';
import '../utils/routes.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    final reservation = ref.watch(reservationSaveProvider);
    final roomPriceState = ref.watch(roomPricesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: trans().continueBooking,
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
          child: Form(
            key: reservationKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: bookingType,
                  items:  [
                    DropdownMenuItem(
                      value: 'Family (Women and Men)',
                      child: Text(trans().family),
                    ),
                    DropdownMenuItem(
                      value: 'Women Only',
                      child: Text(trans().women),
                    ),
                    DropdownMenuItem(
                      value: 'Men Only',
                      child: Text(trans().men),
                    ),
                    DropdownMenuItem(
                      value: 'Companies',
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
                  validator: (value) => value == null ? trans().please_choose_booking_type : null,
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: adultsController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    labelText: trans().adults_count,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? trans().please_enter_adults_count : null,
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: childrenController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    labelText: trans().children_count,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? trans().please_enter_children_count : null,
                ),
                const SizedBox(height: 32),
                // ElevatedButton(
                //   onPressed: reservation.isLoading()
                //       ? null
                //       : () async {
                //     if (reservationKey.currentState!.validate()) {
                //       final adultsCount = adultsController.text.isNotEmpty
                //           ? int.parse(adultsController.text)
                //           : 0;
                //       final childrenCount = childrenController.text.isNotEmpty
                //           ? int.parse(childrenController.text)
                //           : 0;
                //       final bookingType = this.bookingType ?? '';
                //
                //       if (bookingType.isEmpty || adultsCount == 0 || childrenCount == 0) {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(content: Text('الرجاء إكمال البيانات بشكل صحيح')),
                //         );
                //         return;
                //       }
                //
                //       try {
                //         await ref.read(reservationSaveProvider.notifier).saveReservation(
                //           reservation.data!,
                //           adultsCount: adultsCount,
                //           childrenCount: childrenCount,
                //           bookingType: bookingType,
                //         );
                //
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(content: Text('تم الحفظ بنجاح')),
                //         );
                //
                //         // التوجيه إلى صفحة تفاصيل الحجز
                //         // Navigator.pushNamed(
                //         //   context,
                //         //   Routes.reservationDetails, // استخدم المسار المحدد
                //         //   arguments: widget.roomPrice.id, // تمرير roomPriceId كمعرّف
                //        // );
                //       } catch (error) {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(content: Text('حدث خطأ أثناء الحفظ')),
                //         );
                //       }
                //     } else {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text('الرجاء إكمال البيانات بشكل صحيح')),
                //       );
                //     }
                //   },
                //   child: reservation.isLoading()
                //       ? const CircularProgressIndicator()
                //       :  Text(trans().completeTheReservation),
                // ),
                ElevatedButton(
                  onPressed: reservation.isLoading()
                      ? null
                      : () async {
                    if (reservationKey.currentState!.validate()) {
                      final adultsCount = adultsController.text.isNotEmpty
                          ? int.parse(adultsController.text)
                          : 0;
                      final childrenCount = childrenController.text.isNotEmpty
                          ? int.parse(childrenController.text)
                          : 0;
                      final bookingType = this.bookingType ?? '';

                      if (bookingType.isEmpty || adultsCount == 0 || childrenCount == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('الرجاء إكمال البيانات بشكل صحيح')),
                        );
                        return;
                      }

                      try {
                        await ref.read(reservationSaveProvider.notifier).saveReservation(
                          reservation.data!,
                          adultsCount: adultsCount,
                          childrenCount: childrenCount,
                          bookingType: bookingType,
                        );

                        // عرض رسالة تأكيد عند الحفظ بنجاح
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم الحفظ بنجاح')),
                        );

                        // استدعاء تفاصيل الحجز بعد الحفظ
                        final reservationData = reservation.data;
                        await ref.read(reservationProvider.notifier).fetch(
                          roomPriceId: reservationData?.roomPriceId ?? 0,
                        );

                        // الانتقال إلى صفحة تفاصيل الحجز
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.reservationDetails,  // استخدم المسار المحدد
                              (r) => false,  // حذف جميع الصفحات السابقة
                          arguments: reservationData?.roomPriceId, // تمرير roomPriceId كمعرّف
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('حدث خطأ أثناء الحفظ')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('الرجاء إكمال البيانات بشكل صحيح')),
                      );
                    }
                  },
                  child: reservation.isLoading()
                      ? const CircularProgressIndicator()
                      : Text(trans().completeTheReservation),
                ),

                // زر إتمام الحجز
                // ElevatedButton(
                //   onPressed: reservation.isLoading()
                //       ? null
                //       : () async {
                //     if (reservationKey.currentState!.validate()) {
                //       // حفظ البيانات بعد التحقق
                //       try {
                //         await ref.read(reservationSaveProvider.notifier).saveReservation(
                //           reservation.data!, // الحجز الذي سيتم حفظه
                //         );
                //         // عرض رسالة تأكيد عند الحفظ بنجاح
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(content: Text('تم الحفظ بنجاح')),
                //         );
                //         // التوجيه إلى صفحة تفاصيل الحجز بعد الحفظ بنجاح
                //         Navigator.pushNamed(context, Routes.reservationDetails);
                //       } catch (error) {
                //         // في حال حدوث خطأ أثناء الحفظ
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(content: Text('حدث خطأ أثناء الحفظ')),
                //         );
                //       }
                //     } else {
                //       // في حال كانت البيانات غير صالحة
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text('الرجاء إكمال البيانات بشكل صحيح')),
                //       );
                //     }
                //   },
                //   child: reservation.isLoading()
                //       ? const CircularProgressIndicator()
                //       : const Text('إتمام الحجز'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
