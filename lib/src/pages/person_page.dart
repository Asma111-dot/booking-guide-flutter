import 'package:flutter/material.dart';

import '../helpers/general_helper.dart';
import '../utils/theme.dart';

class PersonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          trans().persons,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: CustomTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      backgroundColor: Colors.white70,
      body: Center(
        child: Text(
          'Person Page',
          style: TextStyle(fontSize: 24, color: Colors.blueGrey),
        ),
      ),
    );
  }
}