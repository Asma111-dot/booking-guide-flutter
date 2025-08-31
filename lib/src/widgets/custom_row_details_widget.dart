import 'package:flutter/material.dart';
import '../utils/sizes.dart';
import '../utils/theme.dart';

class CustomRowDetailsWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const CustomRowDetailsWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: CustomTheme.color2,
          size: Sizes.iconS16,
        ),
        Gaps.w8,
        Text(
          label,
          style: TextStyle(
            fontSize: TFont.m14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: TFont.m14,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
