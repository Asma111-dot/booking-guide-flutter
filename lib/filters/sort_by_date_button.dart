import 'package:flutter/material.dart';

class SortByDateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SortByDateButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // يشغل عرض الصف بأكمله
      child: ElevatedButton.icon(
        onPressed: () {
          // عند الضغط على الزر، الانتقال إلى واجهة جديدة
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DateSortingScreen()),
          );
        },
        icon: Icon(Icons.calendar_today, color: Colors.white),
        label: Text(
          'الفرز حسب التاريخ',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[500],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}

// واجهة جديدة (CustomCalendarWidget هنا للتوضيح)
class DateSortingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الفرز حسب التاريخ'),
        backgroundColor: Colors.grey[500],
      ),
      body: Center(
        child: Text(
          'هنا يمكنك عرض واجهة الفرز حسب التاريخ',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
