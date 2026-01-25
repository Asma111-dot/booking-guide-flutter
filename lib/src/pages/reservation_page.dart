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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    adultsController = TextEditingController();
    childrenController = TextEditingController();
  }

  InputDecoration _inputDecoration(BuildContext context, String label,
      {bool hasError = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: hasError ? colorScheme.error : colorScheme.secondary,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: theme.inputDecorationTheme.fillColor ?? colorScheme.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.secondary, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.error, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.error, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      errorStyle: TextStyle(
        color: colorScheme.error,
        fontWeight: FontWeight.bold,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
        onLoaded: (data) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Form(
              key: reservationKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       Icon(arrowdownIcon, size: 16, color: CustomTheme.color4),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          trans().booking_type_hint,
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7)),
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
                        child: Text(
                          trans().family,
                          style: TextStyle(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'نساء',
                        child: Text(
                          trans().women,
                          style: TextStyle(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'رجال',
                        child: Text(
                          trans().men,
                          style: TextStyle(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'شركة',
                        child: Text(
                          trans().companies,
                          style: TextStyle(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => bookingType = value),
                    decoration: _inputDecoration(context, trans().booking_type),
                    validator: (value) => value == null
                        ? trans().please_choose_booking_type
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(groups2Icon, size: 16, color: CustomTheme.color4),
                      const SizedBox(width: 6),
                      Text(trans().adults_hint,
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: adultsController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.color2,
                      fontSize: 16,
                    ),
                    decoration: _inputDecoration(context, trans().adults_count),
                    validator: (value) => value!.isEmpty
                        ? trans().please_enter_adults_count
                        : null,
                    onChanged: (value) {
                      final normalized = convertToEnglishNumbers(value);
                      if (value != normalized) {
                        adultsController.value = TextEditingValue(
                          text: normalized,
                          selection: TextSelection.collapsed(
                              offset: normalized.length),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(childIcon, size: 16, color: CustomTheme.color4),
                      const SizedBox(width: 6),
                      Text(trans().children_hint,
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: childrenController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.color2,
                      fontSize: 16,
                    ),
                    decoration:
                        _inputDecoration(context, trans().children_count),
                    validator: (value) => null,
                    onChanged: (value) {
                      final normalized = convertToEnglishNumbers(value);
                      if (value != normalized) {
                        childrenController.value = TextEditingValue(
                          text: normalized,
                          selection: TextSelection.collapsed(
                              offset: normalized.length),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Button(
              width: double.infinity,
              title: trans().completeTheReservation,
              icon: isLoading
                  ? CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onPrimary,
              )
                  : Icon(
                arrowForWordIcon,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              iconAfterText: true,
              disable: isLoading,
              onPressed: isLoading
                  ? null
                  : () async {
                if (reservationKey.currentState!.validate()) {
                  setState(() => isLoading = true);

                  final adultsCount =
                  int.parse(adultsController.text.trim());
                  final childrenCount =
                  childrenController.text.isNotEmpty
                      ? int.parse(childrenController.text.trim())
                      : 0;

                  try {
                    final savedReservation = await ref
                        .read(reservationSaveProvider.notifier)
                        .saveReservation(
                      reservation.data!,
                      adultsCount: adultsCount,
                      childrenCount: childrenCount,
                      bookingType: bookingType!,
                    );

                    if (savedReservation != null &&
                        savedReservation.id != 0) {
                      await ref.read(reservationProvider.notifier).fetch(
                        reservationId: savedReservation.id,
                      );

                      setState(() => isLoading = false);

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.reservationDetails,
                            (r) => false,
                        arguments: savedReservation.id,
                      );
                    } else {
                      setState(() => isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "حدثت مشكلة في جلب تفاصيل الحجز، حاول مرة أخرى.",
                          ),
                        ),
                      );
                    }
                  } catch (_) {
                    setState(() => isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(trans().error_occurred_during_save),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text(trans().please_complete_data_correctly),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
