import 'package:flutter/material.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("حجوزاتي"),
      ),
      body: Center(
        child: const Text(
          "صفحة حجوزاتي",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
