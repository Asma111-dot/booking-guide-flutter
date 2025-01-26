import 'package:flutter/material.dart';

import 'filter_button.dart';
import 'map_button.dart';
import 'sort_by_date_button.dart';

class ActionButtonsRow extends StatelessWidget {
  const ActionButtonsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // الصف الأول: زر الفرز حسب التاريخ
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0), // مسافة بين الصفوف
          child: SortByDateButton(
            onPressed: () {
              print("فرز حسب التاريخ");
              // استدعِ الوظيفة الخاصة بتحديث البيانات
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FilterButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: Text('الفلتر')),
                      body: Center(
                        child: Text('هنا يمكن عرض الفلتره'),
                      ),
                    ),
                  ),
                );
              },
            ),
            MapButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: Text('الخريطة')),
                      body: Center(
                        child: Text('هنا يمكن عرض الخريطة'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
