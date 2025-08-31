import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/dialog_helper.dart';
import '../helpers/general_helper.dart';
import '../providers/reservation/reservation_provider.dart';
import '../models/reservation.dart' as res;
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/sizes.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../widgets/reservation_details_content.dart';
import '../widgets/view_widget.dart';

class ReservationDetailsPage extends ConsumerStatefulWidget {
  final int reservationId;

  const ReservationDetailsPage({
    super.key,
    required this.reservationId,
  });

  @override
  ConsumerState<ReservationDetailsPage> createState() =>
      _ReservationDetailsPageState();
}

class _ReservationDetailsPageState
    extends ConsumerState<ReservationDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(reservationProvider.notifier)
          .fetch(reservationId: widget.reservationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationState = ref.watch(reservationProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () => confirmExitToHome(context),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBarClipper(
          title: trans().reservationDetails,
        ),
        resizeToAvoidBottomInset: true,
        body: ViewWidget<res.Reservation>(
          meta: reservationState.meta,
          data: reservationState.data,
          refresh: () async => await ref
              .read(reservationProvider.notifier)
              .fetch(reservationId: widget.reservationId),
          forceShowLoaded: reservationState.data != null,
          onLoaded: (data) => ReservationDetailsContent(data: data),
          onLoading: () => const Center(child: CircularProgressIndicator()),
          onEmpty: () => Center(child: Text(trans().no_data)),
          showError: true,
          showEmpty: true,
        ),
        bottomNavigationBar: SafeArea(
          minimum: EdgeInsets.all(Insets.m16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: S.h(8)),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withOpacity(0.2),
                  borderRadius: Corners.sm8,
                ),
                child: Row(
                  children: [
                    Icon(errorIcon, color: colorScheme.secondary),
                    Gaps.w8,
                    Expanded(
                      child: Text(
                        trans().booking_not_confirmed_warning,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.h12,
              OutlinedButton.icon(
                onPressed: () async {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.navigationMenu,
                        (route) => false,
                  );
                },
                icon: const Icon(goBackIcon),
                label: Text(trans().go_back),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.outline),
                  padding: EdgeInsets.symmetric(vertical: S.h(12)),
                ),
              ),
              Gaps.h12,
              Button(
                width: double.infinity,
                title: trans().payment_now,
                icon: Icon(
                  arrowForWordIcon,
                  size: Sizes.iconM20,
                  color: colorScheme.onPrimary,
                ),
                iconAfterText: true,
                disable: false,
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    Routes.payment,
                    arguments: reservationState.data?.id,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
