import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/sizes.dart';

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
        margin: EdgeInsets.symmetric(vertical: Insets.xs8),
        padding: EdgeInsets.all(S.h(8)),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: Corners.md15,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black12 : Colors.grey.withOpacity(0.1),
              blurRadius: S.r(6),
              offset: Offset(0, S.h(2)),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // صورة المنشأة
            Container(
              width: S.w(110),
              height: S.h(110),
              decoration: BoxDecoration(
                color: highlightColor,
                borderRadius: Corners.md15,
              ),
            ),
            Gaps.w12,
            // تفاصيل المنشأة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنشأة
                  Container(
                    height: S.h(16),
                    width: double.infinity,
                    color: highlightColor,
                  ),
                  Gaps.h6,
                  // السعر
                  Container(
                    width: S.w(120),
                    height: S.h(14),
                    color: highlightColor,
                  ),
                  Gaps.h6,
                  // الموقع
                  Row(
                    children: [
                      Container(
                        width: S.w(14),
                        height: S.h(14),
                        decoration: BoxDecoration(
                          color: highlightColor,
                          borderRadius: Corners.sm8,

                        ),
                      ),
                      Gaps.w4,
                      Expanded(
                        child: Container(
                          height: S.h(14),
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
