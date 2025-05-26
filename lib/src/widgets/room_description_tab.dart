import 'package:flutter/material.dart';
import '../models/facility.dart';
import '../models/room.dart' as r;
import '../utils/theme.dart';
import '../helpers/general_helper.dart';

class RoomDescriptionTab extends StatelessWidget {
  final Facility facility;
  final r.Room room;
  final bool showAboutFull;
  final bool showTypeFull;
  final bool showDescFull;
  final ValueChanged<bool> onShowAboutToggle;
  final ValueChanged<bool> onShowTypeToggle;
  final ValueChanged<bool> onShowDescToggle;

  const RoomDescriptionTab({
    super.key,
    required this.facility,
    required this.room,
    required this.showAboutFull,
    required this.showTypeFull,
    required this.showDescFull,
    required this.onShowAboutToggle,
    required this.onShowTypeToggle,
    required this.onShowDescToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trans().about_facility,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CustomTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            facility.desc,
            style: const TextStyle(fontSize: 16),
            maxLines: showAboutFull ? null : 2,
            overflow:
            showAboutFull ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (facility.desc.length > 150)
            TextButton(
              onPressed: () => onShowAboutToggle(!showAboutFull),
              child: Text(showAboutFull ? 'عرض أقل' : 'قراءة المزيد'),
            ),

          const Divider(),
          const SizedBox(height: 8),

          Text(
            trans().read_terms_before_booking,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CustomTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            room.type,
            style: const TextStyle(fontSize: 16),
            maxLines: showTypeFull ? null : 2,
            overflow:
            showTypeFull ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (room.type.length > 150)
            TextButton(
              onPressed: () => onShowTypeToggle(!showTypeFull),
              child: Text(showTypeFull ? 'عرض أقل' : 'قراءة المزيد'),
            ),

          const Divider(),
          const SizedBox(height: 8),

          Text(
            trans().insurance_coverage_question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CustomTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            room.desc,
            style: const TextStyle(fontSize: 16),
            maxLines: showDescFull ? null : 2,
            overflow:
            showDescFull ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          if (room.desc.length > 150)
            TextButton(
              onPressed: () => onShowDescToggle(!showDescFull),
              child: Text(showDescFull ? 'عرض أقل' : 'قراءة المزيد'),
            ),
        ],
      ),
    );
  }
}
