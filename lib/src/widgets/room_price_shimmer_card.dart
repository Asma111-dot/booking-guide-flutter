import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 140, // ✅ لتجنب overflow، يمكن تعديله حسب التصميم
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ لحل مشكلة overflow
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(5, (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: highlightColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 14,
                      color: highlightColor,
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
