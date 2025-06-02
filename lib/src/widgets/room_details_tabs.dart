import 'package:flutter/material.dart';

import '../models/facility.dart';
import '../models/room.dart' as r;
import '../utils/theme.dart';
import '../helpers/general_helper.dart';
import 'room_description_tab.dart';
import 'room_amenities_tab.dart';
import 'room_prices_tab.dart';

class RoomDetailsTabs extends StatelessWidget {
  final r.Room room;
  final Facility facility;
  final TabController tabController;
  final bool showAboutFull;
  final bool showTypeFull;
  final bool showDescFull;
  final ValueChanged<bool> onShowAboutToggle;
  final ValueChanged<bool> onShowTypeToggle;
  final ValueChanged<bool> onShowDescToggle;

  const RoomDetailsTabs({
    super.key,
    required this.room,
    required this.facility,
    required this.tabController,
    required this.showAboutFull,
    required this.showTypeFull,
    required this.showDescFull,
    required this.onShowAboutToggle,
    required this.onShowTypeToggle,
    required this.onShowDescToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: tabController,
          labelColor:CustomTheme.color3,
          unselectedLabelColor: Colors.grey,
          indicatorColor: CustomTheme.color3,
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          tabs: [
            Tab(text: trans().description),
            Tab(text: trans().amenity),
            Tab(text: trans().price_list),
          ],
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: tabController,
            children: [
              RoomDescriptionTab(
                facility: facility,
                room: room,
                showAboutFull: showAboutFull,
                showTypeFull: showTypeFull,
                showDescFull: showDescFull,
                onShowAboutToggle: onShowAboutToggle,
                onShowTypeToggle: onShowTypeToggle,
                onShowDescToggle: onShowDescToggle,
              ),
              RoomAmenitiesTab(room: room),
              RoomPricesTab(room: room),
            ],
          ),
        ),
      ],
    );
  }
}
