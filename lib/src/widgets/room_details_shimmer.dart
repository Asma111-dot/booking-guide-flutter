import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
            height: 300,
            width: double.infinity,
            color: color,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Shimmer.fromColors(
            baseColor: color,
            highlightColor: color.withOpacity(0.3),
            child: Container(
              height: 24,
              width: 150,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Shimmer.fromColors(
            baseColor: color,
            highlightColor: color.withOpacity(0.3),
            child: Container(
              height: 14,
              width: double.infinity,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
