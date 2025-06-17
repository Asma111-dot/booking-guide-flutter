import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FacilityShimmerCard extends StatelessWidget {
  const FacilityShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black12 : Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // صورة المنشأة
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: highlightColor,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(width: 12),
            // تفاصيل المنشأة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنشأة
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: highlightColor,
                  ),
                  const SizedBox(height: 6),
                  // السعر
                  Container(
                    height: 14,
                    width: 120,
                    color: highlightColor,
                  ),
                  const SizedBox(height: 6),
                  // الموقع
                  Row(
                    children: [
                      Container(
                        height: 14,
                        width: 14,
                        decoration: BoxDecoration(
                          color: highlightColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 14,
                          color: highlightColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // زر القلب
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: highlightColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
