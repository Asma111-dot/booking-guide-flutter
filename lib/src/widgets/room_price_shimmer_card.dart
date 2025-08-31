import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/sizes.dart';

class RoomPriceShimmerCard extends StatelessWidget {
  const RoomPriceShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        margin: EdgeInsets.symmetric(horizontal: Insets.xs8),
        padding: EdgeInsets.all(S.h(10)),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: Corners.sm8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(5, (index) => Padding(
            padding: EdgeInsets.symmetric(vertical: S.h(5)),
            child: Row(
              children: [
                Container(
                  width: S.w(20),
                  height: S.h(20),
                  decoration: BoxDecoration(
                    color: highlightColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Gaps.w12,
                Expanded(
                  child: Container(
                    height: S.h(14),
                    color: highlightColor,
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
