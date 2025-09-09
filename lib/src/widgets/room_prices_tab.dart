import 'package:flutter/material.dart';
import '../models/room.dart' as r;
import '../helpers/general_helper.dart';
import '../utils/sizes.dart';
import 'room_price_widget.dart';

class RoomPricesTab extends StatelessWidget {
  final r.Room room;

  const RoomPricesTab({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Insets.s12, horizontal: S.w(4)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            room.roomPrices.isNotEmpty
                ? ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: room.roomPrices
                        .map((price) => RoomPriceWidget(price: price))
                        .toList(),
                  )
                : Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Center(
                      child: Text(
                        trans().priceNotAvailable,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
