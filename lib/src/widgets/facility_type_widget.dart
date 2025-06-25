import 'package:flutter/material.dart';

class FacilityTypeWidget extends StatelessWidget {
  final String title;
  final int typeId;
  final int? selectedFacilityType;
  final IconData icon;
  final void Function(int typeId) onTap;

  const FacilityTypeWidget({
    super.key,
    required this.title,
    required this.typeId,
    required this.selectedFacilityType,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedFacilityType == typeId;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => onTap(typeId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.secondary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.secondary : colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
