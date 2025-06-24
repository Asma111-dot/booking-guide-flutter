import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/payment_method.dart';
import '../helpers/general_helper.dart';
import '../models/payment.dart' as pay;
import '../providers/payment/payment_confirm_provider.dart';
import '../providers/payment/payment_save_provider.dart';
import '../utils/assets.dart';
import '../utils/dialogs.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final int reservationId;

  const PaymentPage({super.key, required this.reservationId});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  PaymentMethod? selectedPaymentMethod;
  int? paymentId;
  bool isLoading = false;

  // String getCustomFallbackMessage(pay.Payment payment) {
  //   if (payment.amount == 0) return 'المبلغ غير صالح.';
  //   return 'حدث خطأ غير متوقع. يرجى المحاولة لاحقًا.';
  // }

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
            ...PaymentMethod.values.map((method) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = method;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedPaymentMethod == method
                          ? colorScheme.primary
                          : colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          method.image,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            color: colorScheme.error,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          method.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        selectedPaymentMethod == method
                            ? radioCheckIcon
                            : radioOutIcon,
                        color: selectedPaymentMethod == method
                            ? colorScheme.primary
                            : colorScheme.outline,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
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
                : Icon(arrowForWordIcon, size: 20, color: colorScheme.onPrimary),
            iconAfterText: true,
          onPressed: selectedPaymentMethod == null || isLoading
              ? null
              : () async {
            setState(() => isLoading = true);
            debugPrint("====== [PAYMENT PROCESS STARTED] ======");
            debugPrint("🔹 Selected Method: ${selectedPaymentMethod?.name} (ID: ${selectedPaymentMethod?.id})");
            debugPrint("🔹 Reservation ID: ${widget.reservationId}");

            final payment = pay.Payment.basic(
              reservationId: widget.reservationId,
              paymentMethodId: selectedPaymentMethod!.id,
            );

            debugPrint("➡️ Creating payment...");
            debugPrint("🧾 Payload: ${payment.toJson()}");

            await paymentState.savePayment(payment);
            final currentState = ref.read(paymentSaveProvider);

            debugPrint("🔄 Save Response Meta: ${currentState.meta}");
            debugPrint("📦 Saved Payment: ${currentState.data}");

            // ❌ إذا فشل الحفظ لأي سبب
            if (!currentState.isLoaded()) {
              setState(() => isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(currentState.meta.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
              return;
            }

            final savedPayment = currentState.data!;
            paymentId = savedPayment.id;
            final isSuccess = savedPayment.response?.isSuccess ?? false;
            final netAmount = savedPayment.response?.purchase?.net ?? 0;

            debugPrint("✅ Payment created successfully! ID: ${savedPayment.id}");
            debugPrint("📌 isSuccess = $isSuccess");
            debugPrint("📌 netAmount = $netAmount");

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
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
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

                        if (confirmationCode != null && paymentId != null) {
                          Navigator.of(context).pop(); // Close OTP dialog
                          showWaitingDialog(context); // Show waiting dialog

                          debugPrint("➡️ Sending OTP confirmation: $confirmationCode for payment ID: $paymentId");

                          await paymentConfirm.confirmPayment(paymentId!, confirmationCode);

                          Navigator.of(context, rootNavigator: true).pop(); // Close waiting dialog

                          final confirmState = ref.read(paymentConfirmProvider);

                          debugPrint("🔄 Confirm Response Meta: ${confirmState.meta}");
                          debugPrint("📦 Confirmed Payment: ${confirmState.data}");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                confirmState.isLoaded()
                                    ? trans().payment_confirmed_successfully
                                    : confirmState.meta.message,
                              ),
                              backgroundColor: confirmState.isLoaded()
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.error,
                            ),
                          );
                        } else {
                          debugPrint("❌ Invalid or missing OTP.");
                        }
                      },
                      child: Text(trans().verify),
                    ),
                  ],
                );
              },
            );

            setState(() => isLoading = false);
            debugPrint("====== [PAYMENT PROCESS ENDED] ======");
          },
        ),
      ),
    );
  }
}
