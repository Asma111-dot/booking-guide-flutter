import 'package:flutter/material.dart';

class CustomAppBarClipper extends StatelessWidget {
  final Color backgroundColor;
  final double height;
  final Widget? child;

  const CustomAppBarClipper({
    Key? key,
    required this.backgroundColor,
    this.height = 180.0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _AppBarClipper(),
      child: Container(
        height: height,
        color: backgroundColor,
        child: child ?? SizedBox.shrink(),
      ),
    );
  }
}

class _AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 60);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 120, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
