import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../enums/reservation_status.dart';
import '../extensions/date_formatting.dart';
import '../helpers/general_helper.dart';
import '../models/reservation.dart' as r;
import '../models/status.dart';
import '../providers/reservation/reservations_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../utils/sizes.dart';
import '../widgets/facility_shimmer_card.dart';
import '../widgets/shimmer_image_placeholder.dart';

class BookingPage extends ConsumerStatefulWidget {
  final int userId;

  const BookingPage({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool _firstLoad = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref
          .read(reservationsProvider.notifier)
          .fetch(userId: widget.userId);

      if (mounted) {
        setState(() {
          _firstLoad = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final reservationState = ref.watch(reservationsProvider);
    final textTheme = Theme.of(context).textTheme;
    final isFirstEmpty = _firstLoad && (reservationState.data?.isEmpty ?? true);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            trans().booking,
            style: textTheme.headlineMedium?.copyWith(
              color: CustomTheme.color2,
              fontWeight: FontWeight.bold,
              fontSize: TFont.xl18,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.onSurface),
          bottom: TabBar(
            indicatorColor: CustomTheme.color4,
            labelColor: CustomTheme.color3,
            unselectedLabelColor: Colors.grey,
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            tabs: [
              Tab(text: trans().all),
              Tab(text: trans().confirmed),
              Tab(text: trans().cancelled),
            ],
          ),
        ),
        body: reservationState.isLoading == true || isFirstEmpty
            ? ListView.builder(
                padding: EdgeInsets.all(Insets.m16),
                itemCount: 5,
                itemBuilder: (_, __) => const FacilityShimmerCard(),
              )
            : TabBarView(
                children: [
                  _buildReservationList(reservationState.data, null),
                  _buildReservationList(
                      reservationState.data, ReservationStatus.confirmed),
                  _buildReservationList(
                      reservationState.data, ReservationStatus.cancelled),
                ],
              ),
      ),
    );
  }

  Widget _buildReservationList(
      List<r.Reservation>? all, ReservationStatus? status) {
    final reservations = status == null
        ? (all ?? [])
        : (all ?? []).where((r) => parseStatus(r.status) == status).toList();

    final textTheme = Theme.of(context).textTheme;

    if (reservations.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.m16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                linkIconSvg,
                width: S.w(140),
                height: S.w(140),
              ),
              Gaps.h12,
              Text(
                trans().noReservations,
                textAlign: TextAlign.center,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Gaps.h12,
              Text(
                trans().noReservationsHint,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(Insets.m16),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        final placeName = reservation.roomPrice?.room?.facility?.name ?? '---';
        final logo = reservation.roomPrice?.room?.facility?.logo;
        final imageUrl =
            (logo != null && logo.isNotEmpty) ? logo : logoCoverImage;

        final checkIn = reservation.checkInDate;
        final checkOut = reservation.checkOutDate;
        final daysCount = checkOut.difference(checkIn).inDays + 1;
        final showDays = daysCount > 0;

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.bookingDetails,
              arguments: reservation.id,
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: Corners.md15),
            elevation: 1,
            margin: EdgeInsets.only(bottom: Insets.m16),
            child: Padding(
              padding: EdgeInsets.all(Insets.s12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: Corners.md15,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: S.w(110),
                      height: S.w(110),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ShimmerImagePlaceholder(
                          width: S.w(80), height: S.w(80)),
                      errorWidget: (context, url, error) => Image.asset(
                        appIcon,
                        width: S.w(110),
                        height: S.w(110),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Gaps.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          placeName,
                          style: textTheme.titleSmall?.copyWith(
                            color: CustomTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gaps.h6,
                        Text(
                          "${trans().reservation_date} : ${reservation.checkInDate.toDateView()}",
                          style: textTheme.bodySmall?.copyWith(
                            color: CustomTheme.color1,
                          ),
                        ),

                        if (showDays)
                          Padding(
                            padding: EdgeInsets.only(top: S.h(6)),
                            child: Text(
                              "${trans().number_of_days} : ${formatDaysAr(daysCount)}",
                              style: textTheme.bodySmall?.copyWith(
                                color: CustomTheme.color4,
                              ),
                            ),
                          ),

                        Padding(
                          padding: EdgeInsets.only(top: S.h(6)),
                          child: Text(
                            "${trans().check_out_date} : ${reservation.checkOutDate.toDateView()}",
                            style: textTheme.bodySmall?.copyWith(
                              color: CustomTheme.color1,
                            ),
                          ),
                        ),

                        Gaps.h6,
                        Text(
                          "${trans().created_at} : ${reservation.createdAt?.toDateView()}",
                          style: textTheme.bodySmall?.copyWith(
                            color: CustomTheme.color2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "#2025${reservation.id}",
                        style: textTheme.labelLarge?.copyWith(
                          color: CustomTheme.color4,
                          fontFamily: 'Roboto',
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.h4,
                      Text(
                        "${reservation.totalPrice?.toStringAsFixed(0) ?? trans().priceNotAvailable} ${trans().riyalY}",
                        style: textTheme.titleSmall?.copyWith(
                          color: CustomTheme.color3,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.h30,

                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: S.w(12), vertical: S.h(6)),
                        decoration: BoxDecoration(
                          color: _getStatusColor(reservation.status),
                          borderRadius: Corners.md15,
                        ),
                        child: Text(
                          _getStatusText(reservation.status),
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getStatusText(Status? status) => status?.name ?? 'غير معروف';

  Color _getStatusColor(Status? status) {
    switch (parseStatus(status)) {
      case ReservationStatus.confirmed:
        return Colors.green;
      case ReservationStatus.cancelled:
        return Colors.red;
      case ReservationStatus.unknown:
        return Colors.grey;
    }
  }
}
