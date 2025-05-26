import 'package:flutter/material.dart';
import '../models/room.dart' as r;
import '../helpers/general_helper.dart';
import 'room_price_widget.dart';

class RoomPricesTab extends StatelessWidget {
  final r.Room room;
  const RoomPricesTab({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: room.roomPrices.isNotEmpty
          ? ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: room.roomPrices
            .map((price) => RoomPriceWidget(price: price))
            .toList(),
      )
          : Text(
        "${trans().price}: ${trans().priceNotAvailable}",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
