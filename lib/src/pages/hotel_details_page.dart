import 'package:flutter/material.dart';
import '../models/facility.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';

class HotelDetailsPage extends StatelessWidget {
  final Facility facility;

  const HotelDetailsPage({Key? key, required this.facility}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          facility.name,
          style: TextStyle(color: CustomTheme.placeholderColor),
        ),
        backgroundColor: CustomTheme.primaryColor,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // صورة الفندق
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              hotelImage,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),
          Text(
            facility.name,
            style: TextStyle(
              color: CustomTheme.primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            facility.desc,
            style: TextStyle(
              color: CustomTheme.secondaryColor,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomTheme.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'احجز الآن',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
