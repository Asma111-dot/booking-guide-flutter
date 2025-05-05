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

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentSaveProvider.notifier);
    final paymentConfirm = ref.watch(paymentConfirmProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
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
                style: const TextStyle(
                  fontSize: 18,
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
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedPaymentMethod == 'فلوسك'
                        ? CustomTheme.primaryColor
                        : Colors.grey,
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
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error, color: Colors.grey, size: 40);
                      },
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        trans().floosak,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      selectedPaymentMethod == 'فلوسك'
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selectedPaymentMethod == 'فلوسك'
                          ? CustomTheme.primaryColor
                          : Colors.grey,
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
              ? const CircularProgressIndicator(color: CustomTheme.color2)
              : const Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: Colors.white,
                ),
          iconAfterText: true,
          onPressed: selectedPaymentMethod == null || isLoading
              ? null
              : () async {
                  setState(() {
                    isLoading = true;
                  });
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
                            title:  Text((trans().confirm_payment)),
                            content: TextField(
                              controller: confirmationController,
                              keyboardType: TextInputType.number,
                              decoration:  InputDecoration(
                                hintText: trans().enter_confirmation_number,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(trans().cancel),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final confirmationCode =
                                      int.tryParse(confirmationController.text);

                                  if (confirmationCode != null) {
                                    Navigator.of(context).pop();

                                    if (paymentId != null) {
                                      await paymentConfirm.confirmPayment(
                                        paymentId!,
                                        confirmationCode,
                                      );

                                      final confirmState =
                                          ref.read(paymentConfirmProvider);

                                      if (confirmState.isLoaded()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                           SnackBar(
                                            content:
                                                Text(trans().payment_confirmed_successfully),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              confirmState.meta.message
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: Text(trans().verify),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            currentState.meta.message,
                          ),
                        ),
                      );
                    }
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
        ),
      ),
    );
  }
}
