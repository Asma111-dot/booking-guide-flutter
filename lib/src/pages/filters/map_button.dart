import 'package:flutter/material.dart';

import '../../utils/theme.dart';


class MapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MapButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          Icons.map,
          color: CustomTheme.primaryColor,
        ),
        label: Text(
          'خريطة',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          // backgroundColor: CustomTheme.placeholderColor,
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}
