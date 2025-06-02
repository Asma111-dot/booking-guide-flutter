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
          // عن المنشأة
          Text(
            trans().about_facility,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: CustomTheme.color2,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Text(
              facility.desc,
              style: const TextStyle(fontSize: 12),
              maxLines: showAboutFull ? null : 2,
              overflow:
                  showAboutFull ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
          if (facility.desc.length > 150)
            TextButton(
              onPressed: () => onShowAboutToggle(!showAboutFull),
              child: Text(
                showAboutFull ? trans().show_less : trans().read_more,
                style: TextStyle(
                  color: CustomTheme.color3,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const Divider(thickness: 2),
          const SizedBox(height: 8),

          // السياسات
          Text(
            trans().read_terms_before_booking,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: CustomTheme.color2,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Text(
              room.type,
              style: const TextStyle(fontSize: 12),
              maxLines: showTypeFull ? null : 2,
              overflow:
                  showTypeFull ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
          if (room.type.length > 150)
            TextButton(
              onPressed: () => onShowTypeToggle(!showTypeFull),
              child: Text(
                showTypeFull ? trans().show_less : trans().read_more,
                style: TextStyle(
                  color: CustomTheme.color3,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const Divider(thickness: 2),
          const SizedBox(height: 8),

          // التأمين
          Text(
            trans().insurance_coverage_question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: CustomTheme.color2,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Text(
              room.desc,
              style: const TextStyle(fontSize: 12),
              maxLines: showDescFull ? null : 2,
              overflow:
                  showDescFull ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
          if (room.desc.length > 150)
            TextButton(
              onPressed: () => onShowDescToggle(!showDescFull),
              child: Text(
                showDescFull ? trans().show_less : trans().read_more,
                style: TextStyle(
                  color: CustomTheme.color3,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
