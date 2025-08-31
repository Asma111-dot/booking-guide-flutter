import 'package:flutter/material.dart';

import '../utils/sizes.dart';
import '../utils/theme.dart';

class CustomAppBarClipper extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomAppBarClipper({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: CustomTheme.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: S.w(20),
        vertical: S.h(16),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: TextStyle(
            color: CustomTheme.whiteColor,
            fontSize: TFont.x2_20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
