import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/sizes.dart';

class FacilityTypeShimmer extends StatelessWidget {
  const FacilityTypeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: List.generate(5, (index) {
            return Container(
              margin: EdgeInsets.only(right: Insets.xs8),
              padding:
                  EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(8)),
              decoration:
                  BoxDecoration(color: baseColor, borderRadius: Corners.md15),
              child: Row(
                children: [
                  Container(
                    width: S.w(24),
                    height: S.h(24),
                    decoration: BoxDecoration(
                      color: highlightColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gaps.w8,
                  Container(
                    width: S.w(60),
                    height: S.h(14),

                    color: highlightColor,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
