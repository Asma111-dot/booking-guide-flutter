import 'package:flutter_riverpod/flutter_riverpod.dart';

String appName(String locale) => locale == 'ar' ? "دليل الحجوزات" : "Booking Guide";

//how?
const authToken = "";

late WidgetRef globalRef;

// width - height
const double chaletImageRatio = 1;
const double hotelImageRatio = 1;

const double maxChildSize = 1;
const double minChildSize = 0.6;
const double initialChildSize = 0.6;

const double sheetPaddings = 16;
const double sheetMargins = 16;
