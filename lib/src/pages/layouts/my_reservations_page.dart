import 'package:flutter/material.dart';
import 'main_layout.dart';  // تأكد من استيراد MainLayout بشكل صحيح

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1,  // اختيار "حجوزاتي" كـ الصفحة النشطة في الـ BottomNavigationBar
      child: Scaffold(
        appBar: AppBar(
          title: const Text("حجوزاتي"),
        ),
        body: const Center(
          child: Text(
            "صفحة حجوزاتي",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
