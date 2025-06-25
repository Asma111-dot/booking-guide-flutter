import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reservation.dart' as res;
import '../utils/assets.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../widgets/reservation_details_content.dart';
import '../widgets/view_widget.dart';
import '../widgets/button_widget.dart';
import '../utils/routes.dart';
import '../providers/reservation/reservation_provider.dart';
import '../helpers/general_helper.dart';

class BookingDetailsPage extends ConsumerStatefulWidget {
  final int reservationId;

  const BookingDetailsPage({super.key, required this.reservationId});

  @override
  ConsumerState<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends ConsumerState<BookingDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reservationProvider.notifier).fetch(
            reservationId: widget.reservationId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final reservationState = ref.watch(reservationProvider);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: CustomAppBarClipper(
        title: trans().reservationDetails,
      ),
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
        minimum: const EdgeInsets.all(16),
        child: Button(
          width: double.infinity,
          title: trans().viewFacilityDetails,
          icon: Icon(apartmentIcon, color: colorScheme.onPrimary),
          iconAfterText: true,
          disable: false,
          onPressed: () async {
            final facility = reservationState.data?.roomPrice?.room?.facility;
            if (facility != null) {
              Navigator.pushNamed(
                context,
                Routes.roomDetails,
                arguments: facility,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("لا يمكن عرض تفاصيل الغرفة")),
              );
            }
          },
        ),
      ),
    );
  }
}
