import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';

class ChaletsPage extends StatelessWidget {
  const ChaletsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          trans().chalet
        ),
      ),
      body: Center(
        child: Text('قائمة الشاليهات هنا'),
      ),
    );
  }
}
