import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/payment/payment_confirm_provider.dart';
import '../providers/payment/payment_save_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../models/payment.dart' as pay;

class PaymentPage extends ConsumerStatefulWidget {
  final int reservationId;

  const PaymentPage({super.key, required this.reservationId});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  String? selectedPaymentMethod;
  int? paymentId;
  bool isLoading = false;
// خارج الكلاس تمامًا (RoomDetailsPage مثلًا)

  String getCustomFallbackMessage(pay.Payment payment) {
    if (payment.amount == 0) return 'المبلغ غير صالح.';
    if (payment.transactionTypeId == 0) return 'نوع المعاملة غير محدد.';
    if (payment.paymentMethodId == 0) return 'طريقة الدفع غير محددة.';
    return 'حدث خطأ غير متوقع. يرجى المحاولة لاحقًا.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final paymentState = ref.watch(paymentSaveProvider.notifier);
    final paymentConfirm = ref.watch(paymentConfirmProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        appTitle: trans().payment,
        icon: arrowBackIcon,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                trans().payment_methods,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedPaymentMethod = 'فلوسك';
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedPaymentMethod == 'فلوسك'
                        ? colorScheme.primary
                        : colorScheme.outline,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      floosakImage,
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(errorIcon, color: colorScheme.error, size: 40),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        trans().floosak,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      selectedPaymentMethod == 'فلوسك'
                          ? radioCheckIcon
                          : radioOutIcon,
                      color: selectedPaymentMethod == 'فلوسك'
                          ? colorScheme.primary
                          : colorScheme.outline,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Button(
          width: MediaQuery.of(context).size.width - 40,
          title: trans().completeTheReservation,
          disable: selectedPaymentMethod == null || isLoading,
          icon: isLoading
              ? CircularProgressIndicator(color: colorScheme.onPrimary)
              : Icon(priceChangeIcon, size: 20, color: colorScheme.onPrimary),
          iconAfterText: true,
          onPressed: selectedPaymentMethod == null || isLoading
              ? null
              : () async {
            setState(() => isLoading = true);
            if (selectedPaymentMethod == 'فلوسك') {
              final payment = pay.Payment.basic(
                reservationId: widget.reservationId,
              );

              await paymentState.savePayment(payment);
              final currentState = ref.read(paymentSaveProvider);

              if (currentState.isLoaded()) {
                paymentId = currentState.data?.id;

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final TextEditingController confirmationController =
                    TextEditingController();

                    return AlertDialog(
                      backgroundColor: colorScheme.background,
                      title: Text(
                        trans().confirm_payment,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: TextField(
                        controller: confirmationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: trans().enter_confirmation_number,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            trans().cancel,
                            style: TextStyle(color: colorScheme.secondary),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final confirmationCode = int.tryParse(
                              convertToEnglishNumbers(
                                confirmationController.text.trim(),
                              ),
                            );

                            if (confirmationCode != null &&
                                paymentId != null) {
                              Navigator.of(context).pop();

                              await paymentConfirm.confirmPayment(
                                paymentId!,
                                confirmationCode,
                              );

                              final confirmState =
                              ref.read(paymentConfirmProvider);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    confirmState.isLoaded()
                                        ? trans().payment_confirmed_successfully
                                        : confirmState.meta.message,
                                    style: TextStyle(
                                      color: confirmState.isLoaded()
                                          ? colorScheme.onPrimary
                                          : colorScheme.onError,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: confirmState.isLoaded()
                                      ? colorScheme.primary
                                      : colorScheme.error,
                                ),
                              );
                            }
                          },
                          child: Text(
                            trans().verify,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // if (mounted) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content: Text(currentState.meta.message),
                //     ),
                //   );
                // }
                final errorMessage = currentState.meta.message.trim().isEmpty
                    ? getCustomFallbackMessage(payment)
                    : currentState.meta.message;

                print('❌ رسالة الخطأ: $errorMessage');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    duration: Duration(seconds: 4),
                  ),
                );

              }
            }
            setState(() => isLoading = false);
          },
        ),
      ),
    );
  }
}
