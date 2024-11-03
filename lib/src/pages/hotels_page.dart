import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';

class HotelsPage extends StatelessWidget {
  const HotelsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          trans().hotel
        ),
      ),
      body: Center(
        child: Text('قائمة الفنادق هنا'),
      ),
    );
  }
}
