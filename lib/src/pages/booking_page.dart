import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../models/reservation.dart' as r;
import '../providers/reservation/reservations_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../extensions/date_formatting.dart';

class BookingPage extends ConsumerStatefulWidget {
  final int userId;

  const BookingPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      setState(() => _isLoading = true);
      await ref.read(reservationsProvider.notifier).fetch(userId: widget.userId);
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationState = ref.watch(reservationsProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            trans().booking,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: CustomTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom:  TabBar(
            indicatorColor: CustomTheme.primaryColor,
            labelColor: CustomTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: trans().all),
              Tab(text: trans().confirmed),
              Tab(text: trans().cancelled)
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            _buildReservationList(reservationState.data, null),
            _buildReservationList(reservationState.data, 'confirmed'),
            _buildReservationList(reservationState.data, 'cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationList(List<r.Reservation>? all, String? status) {
    final reservations = status == null
        ? (all ?? [])
        : (all ?? []).where((r) => r.status == status).toList();

    if (reservations.isEmpty) {
      return Center(child: Text(trans().no_data));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        final placeName = reservation.roomPrice?.room?.name ?? '---';
        final logo = reservation.roomPrice?.room?.facility?.logo;
        final imageUrl = (logo != null && logo.isNotEmpty) ? logo : logoCoverImage;

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset(
                      logoCoverImage,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placeName,
                        style: TextStyle(
                          color: CustomTheme.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${trans().reservation_date} : ${reservation.checkInDate.toDateView()}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${trans().created_at} : ${reservation.createdAt?.toDateView()}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "#${reservation.id}",
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${reservation.totalPrice?.toStringAsFixed(0) ?? trans().priceNotAvailable} ${trans().riyalY}",
                      style: TextStyle(
                        color: CustomTheme.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(reservation.status),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        _getStatusText(reservation.status),
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'confirmed':
        return 'مؤكد';
      case 'cancelled':
        return 'ملغي';
      default:
        return 'غير معروف';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
