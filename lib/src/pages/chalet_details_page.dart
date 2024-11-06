import 'package:booking_guide/src/utils/assets.dart';
import 'package:flutter/material.dart';
import '../models/facility.dart';
import '../utils/theme.dart';

class ChaletDetailsPage extends StatelessWidget {
  final Facility facility;

  ChaletDetailsPage({required this.facility});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(facility.name),
        backgroundColor: CustomTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                chaletImage,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              facility.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CustomTheme.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              facility.desc,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTheme.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "احجز الآن",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
