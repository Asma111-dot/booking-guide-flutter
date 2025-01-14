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
          child: Form(
            key: reservationKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // نوع الحجز
                DropdownButtonFormField<String>(
                  value: bookingType,
                  items: const [
                    DropdownMenuItem(
                      value: 'Family (Women and Men)',
                      child: Text('عائلي(نساء ورجال)'),
                    ),
                    DropdownMenuItem(
                      value: 'Women Only',
                      child: Text('نساء فقط'),
                    ),
                    DropdownMenuItem(
                      value: 'Men Only',
                      child: Text('رجال فقط'),
                    ),
                    DropdownMenuItem(
                      value: 'Companies',
                      child: Text('شركة'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      bookingType = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "نوع الحجز",
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => value == null ? 'الرجاء اختيار نوع الحجز' : null,
                ),
                const SizedBox(height: 30),

                // عدد الكبار
                TextFormField(
                  controller: adultsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "عدد الكبار",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "الرجاء إدخال عدد الكبار" : null,
                ),
                const SizedBox(height: 30),

                // عدد الأطفال
                TextFormField(
                  controller: childrenController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "عدد الأطفال",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "الرجاء إدخال عدد الأطفال" : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: reservation.isLoading()
                      ? null
                      : () async {
                    if (reservationKey.currentState!.validate()) {
                      // استخراج القيم المدخلة في الحقول
                      final adultsCount = adultsController.text.isNotEmpty
                          ? int.parse(adultsController.text)
                          : 0;

                      final childrenCount = childrenController.text.isNotEmpty
                          ? int.parse(childrenController.text)
                          : 0;

                      final bookingType = this.bookingType ?? ''; // هنا يتم التأكد من نوع الحجز

                      // تحقق من أن جميع الحقول تمت تعبئتها بشكل صحيح
                      if (bookingType.isEmpty || adultsCount == 0 || childrenCount == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('الرجاء إكمال البيانات بشكل صحيح')),
                        );
                        return;
                      }

                      try {
                        // إرسال البيانات مع الحجز
                        await ref.read(reservationSaveProvider.notifier).saveReservation(
                          reservation.data!, // الحجز الذي سيتم حفظه
                          adultsCount: adultsCount, // عدد الكبار
                          childrenCount: childrenCount, // عدد الأطفال
                          bookingType: bookingType, // نوع الحجز
                        );

                        // عرض رسالة تأكيد عند الحفظ بنجاح
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم الحفظ بنجاح')),
                        );

                        // التوجيه إلى صفحة تفاصيل الحجز بعد الحفظ بنجاح
                        Navigator.pushNamed(context, Routes.reservationDetails);
                      } catch (error) {
                        // في حال حدوث خطأ أثناء الحفظ
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('حدث خطأ أثناء الحفظ')),
                        );
                      }
                    } else {
                      // في حال كانت البيانات غير صالحة
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('الرجاء إكمال البيانات بشكل صحيح')),
                      );
                    }
                  },
                  child: reservation.isLoading()
                      ? const CircularProgressIndicator()
                      : const Text('إتمام الحجز'),
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
