import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/general_helper.dart';
import '../models/reservation.dart';
import '../widgets/custom_app_bar.dart';

class ReservationPage extends ConsumerStatefulWidget {
  final List<Reservation> reservations;

  const ReservationPage({Key? key, required this.reservations}) : super(key: key);

  @override
  ConsumerState<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends ConsumerState<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  int adultsCount = 0;
  int childrenCount = 0;
  String personType = 'عائلة (رجال ونساء)';

  final List<String> personTypes = [
    'عائلة (رجال ونساء)',
    'أفراد (رجال فقط)',
    'أفراد (نساء فقط)',
    'أخرى'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: trans().availabilityCalendar,
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'بيانات الأشخاص في الحجز',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'قم بتحديد نوع الحضور وعدد الأشخاص الحاضرين للحجز',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: personType,
                decoration: InputDecoration(labelText: 'نوع الأشخاص'),
                items: personTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    personType = value!;
                  });
                },
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('كبار', style: TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (adultsCount > 0) adultsCount--;
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text('$adultsCount', style: TextStyle(fontSize: 18)),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            adultsCount++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('أطفال (اختياري)', style: TextStyle(fontSize: 18)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (childrenCount > 0) childrenCount--;
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text('$childrenCount', style: TextStyle(fontSize: 18)),
                      IconButton(
                        onPressed: () {
                          childrenCount++;
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('السابق'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم الحجز بنجاح')),
                        );
                      }
                    },
                    child: Text('التالي'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}