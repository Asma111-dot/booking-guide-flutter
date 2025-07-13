import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/payment_method.dart';
import '../helpers/general_helper.dart';
import '../helpers/notify_helper.dart';
import '../models/payment.dart' as pay;
import '../providers/payment/payment_cash_provider.dart';
import '../providers/payment/payment_confirm_provider.dart';
import '../providers/payment/payment_jaib_provider.dart';
import '../providers/payment/payment_jawali_provider.dart';
import '../providers/payment/payment_save_provider.dart';
import '../providers/reservation/reservation_provider.dart';
import '../utils/assets.dart';
import '../utils/dialogs.dart';
import '../utils/routes.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_row_details_widget.dart';
import '../widgets/payment_method_tile.dart';

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

  @override
  void initState() {
    super.initState();
    // fetch reservation once
    Future.microtask(() {
      ref
          .read(reservationProvider.notifier)
          .fetch(reservationId: widget.reservationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final reservationState = ref.watch(reservationProvider);
    final reservation = reservationState.data; // may be null while loading
    final jaibPayment = ref.watch(paymentJaibProvider.notifier);
    final jawaliPayment = ref.watch(paymentJawaliProvider.notifier);
    final cashPayment = ref.watch(paymentCashProvider.notifier);
    final paymentSave = ref.watch(paymentSaveProvider.notifier);
    final paymentConfirm = ref.watch(paymentConfirmProvider.notifier);
    late final scaffoldContext = context;

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
            // ───────── مبلغ المستحق ─────────
            if (reservation != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomRowDetailsWidget(
                  icon: depositIcon,
                  label: "${trans().amount_to_be_paid} (${trans().deposit})",
                  value: reservation.totalDeposit != null
                      ? '${reservation.totalDeposit!.toInt()} ${trans().riyalY}'
                      : trans().not_available,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ───────── عنوان وسائل الدفع ─────────
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                trans().payment_methods,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // ───────── قائمة وسائل الدفع ─────────
            ...PaymentMethod.values.map((method) {
              final isDisabled = !(method == PaymentMethod.floosak || method == PaymentMethod.jib || method == PaymentMethod.jawaly || method == PaymentMethod.cash);

              return GestureDetector(
                onTap: isDisabled
                    ? () {
                        showNotify(
                          message:  "وسيلة الدفع تحت الإنشاء حالياً",
                          alert: Alert.info,
                        );
                      }
                    : () {
                        setState(() {
                          selectedPaymentMethod = method;
                        });
                      },
                child: PaymentMethodTile(
                  method: method,
                  selected: selectedPaymentMethod == method,
                  disabled: isDisabled,
                ),
              );
            }),
          ],
        ),
      ),

      // ───────── زر إكمال الحجز ─────────
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Button(
          width: MediaQuery.of(context).size.width - 40,
          title: trans().completeTheReservation,
          disable: selectedPaymentMethod == null || isLoading,
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Icon(arrowForWordIcon, size: 20, color: colorScheme.onPrimary),
          iconAfterText: true,
            onPressed: selectedPaymentMethod == null || isLoading
                ? null
                : () async {

              // [جيب]
              if (selectedPaymentMethod == PaymentMethod.jib) {
                // 1️⃣ Show info notify
                showNotify(
                  message: "يرجى دفع العربون يدويًا عبر جيب ثم إدخال الكود المستلم.",
                  alert: Alert.info,
                );

                // 2️⃣ Open dialog for code entry
                final TextEditingController confirmationController =
                TextEditingController();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: colorScheme.background,
                      title: Text(
                        (trans().enter_payment_code),
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
                          hintText: trans().enter_code_from_wallet,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(trans().cancel),
                        ),
                        TextButton(
                          onPressed: () async {
                            final code = confirmationController.text.trim();
                            Navigator.of(context).pop();

                            final waitingDialogCompleter = Completer<BuildContext>();
                            showWaitingDialog(scaffoldContext, (dialogCtx) {
                              waitingDialogCompleter.complete(dialogCtx);
                            });

                            try {
                              await jaibPayment.confirmJaibPayment(
                                reservationId: widget.reservationId,
                                paymentMethodId: selectedPaymentMethod!.id,
                                code: code,
                              );
                            } finally {
                              if (mounted) {
                                final dialogCtx = await waitingDialogCompleter.future;
                                Navigator.of(dialogCtx, rootNavigator: true).pop();
                              }
                            }

                            final state = ref.read(paymentJaibProvider);

                            if (state.isLoaded()) {
                              showNotify(
                                // message: "✅ تم تأكيد الدفع عبر محفظة جيب بنجاح",
                                message: state.meta.message,
                                alert: Alert.success,
                              );

                              await Future.delayed(
                                  const Duration(milliseconds: 300));

                              Navigator.of(scaffoldContext).pushNamedAndRemoveUntil(
                                Routes.paymentDetails,
                                    (r) => false,
                                arguments: state.data?.id,
                              );
                            } else {
                              showNotify(
                                message: state.meta.message,
                                alert: Alert.info,
                              );
                            }
                          },
                          child: Text(trans().verify),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              // [جوالي]
              if (selectedPaymentMethod == PaymentMethod.jawaly) {
                final waitingDialogCompleter = Completer<BuildContext>();
                showWaitingDialog(scaffoldContext, (dialogCtx) {
                  waitingDialogCompleter.complete(dialogCtx);
                });

                try {
                  await jawaliPayment.payJawali(
                    reservationId: widget.reservationId,
                    paymentMethodId: selectedPaymentMethod!.id,
                    voucher: "VOUCHER_CODE_FROM_UI", // احصل عليه من TextField إذا أردت
                    purpose: "الغرض من الحجز",
                  );
                } finally {
                  if (mounted) {
                    final dialogCtx = await waitingDialogCompleter.future;
                    Navigator.of(dialogCtx, rootNavigator: true).pop();
                  }
                }

                final state = ref.read(paymentJawaliProvider);

                if (state.isLoaded()) {
                  showNotify(
                    message: state.meta.message,
                    alert: Alert.success,
                  );

                  await Future.delayed(const Duration(milliseconds: 300));

                  Navigator.of(scaffoldContext).pushNamedAndRemoveUntil(
                    Routes.paymentDetails,
                        (r) => false,
                    arguments: state.data?.id,
                  );
                } else {
                  showNotify(
                    message: state.meta.message,
                    alert: Alert.info,
                  );
                }
                return;
              }

              // [كاش]
              if (selectedPaymentMethod == PaymentMethod.cash) {
                final waitingDialogCompleter = Completer<BuildContext>();
                showWaitingDialog(scaffoldContext, (dialogCtx) {
                  waitingDialogCompleter.complete(dialogCtx);
                });

                try {
                  await cashPayment.payCash(
                    reservationId: widget.reservationId,
                    paymentMethodId: selectedPaymentMethod!.id,
                    purpose: "حجز غرفة",
                  );
                } finally {
                  if (mounted) {
                    final dialogCtx = await waitingDialogCompleter.future;
                    Navigator.of(dialogCtx, rootNavigator: true).pop();
                  }
                }

                final state = ref.read(paymentCashProvider);

                if (state.isLoaded()) {
                  showNotify(
                    message: state.meta.message,
                    alert: Alert.success,
                  );

                  await Future.delayed(const Duration(milliseconds: 300));

                  Navigator.of(scaffoldContext).pushNamedAndRemoveUntil(
                    Routes.paymentDetails,
                        (r) => false,
                    arguments: state.data?.id,
                  );
                } else {
                  showNotify(
                    message: state.meta.message,
                    alert: Alert.info,
                  );
                }
                return;
              }

              // فلوسك
            setState(() => isLoading = true);
                  debugPrint("====== [FLOOSAK PAYMENT PROCESS STARTED] ======");

                  final payment = pay.Payment.basic(
                    reservationId: widget.reservationId,
                    paymentMethodId: selectedPaymentMethod!.id,
                  );

                  await paymentSave.savePayment(payment);
                  final currentState = ref.read(paymentSaveProvider);

                  if (!currentState.isLoaded()) {
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
                            child: Text(trans().cancel),
                          ),
                          TextButton(
                            onPressed: () async {
                              final confirmationCode = int.tryParse(
                                convertToEnglishNumbers(
                                    confirmationController.text.trim()),
                              );

                              if (confirmationCode != null &&
                                  paymentId != null) {
                                Navigator.of(context)
                                    .pop(); // أغلق الـ dialog الحالي
                                final waitingDialogCompleter =
                                    Completer<BuildContext>();

                                showWaitingDialog(scaffoldContext, (dialogCtx) {
                                  waitingDialogCompleter.complete(dialogCtx);
                                });

                                try {
                                  await paymentConfirm.confirmPayment(
                                      paymentId!, confirmationCode);
                                } finally {
                                  if (mounted) {
                                    final dialogCtx =
                                        await waitingDialogCompleter.future;
                                    Navigator.of(dialogCtx, rootNavigator: true)
                                        .pop();
                                  }
                                }

                                final confirmState = ref
                                    .read(paymentConfirmProvider.notifier).state;

                                if (!confirmState.isLoaded()) {
                                  if (mounted) {
                                    showNotify(
                                      message: confirmState.meta.message,
                                      alert: Alert.info,
                                    );
                                  }
                                  return;
                                }
                                if (mounted) {
                                  showNotify(
                                    message:
                                        trans().payment_confirmed_successfully,
                                    alert: Alert.success,
                                  );

                                  await Future.delayed(const Duration(milliseconds: 300));

                                  Navigator.of(scaffoldContext)
                                      .pushNamedAndRemoveUntil(
                                    Routes.paymentDetails,
                                    (r) => false,
                                    arguments: paymentId,
                                  );
                                }
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
