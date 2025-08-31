import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/sizes.dart';

class RoomDetailsShimmer extends StatelessWidget {
  const RoomDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: color,
          highlightColor: color.withOpacity(0.3),
          child: Container(
            height: S.h(300),
            width: double.infinity,
            color: color,
          ),
        ),
        Gaps.h15,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: S.h(16)),
          child: Shimmer.fromColors(
            baseColor: color,
            highlightColor: color.withOpacity(0.3),
            child: Container(
              width: S.w(150),
              height: S.h(24),
              color: color,
            ),
          ),
        ),
        Gaps.h8,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: S.h(16)),
          child: Shimmer.fromColors(
            baseColor: color,
            highlightColor: color.withOpacity(0.3),
            child: Container(
              height: S.h(16),
              width: double.infinity,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
