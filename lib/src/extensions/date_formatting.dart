import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/public/settings_provider.dart';
import '../utils/global.dart';


locale() => globalRef.read(settingsProvider).languageCode;

extension StringFormatting on DateTime {

//SQL (YYYY-MM-DD HH:MM:SS)
  String toSql() {
    return "${year.toString().padLeft(2, '0')}"
        "-${month.toString().padLeft(2, '0')}"
        "-${day.toString().padLeft(2, '0')} "
        "${hour.toString().padLeft(2, '0')}"
        ":${minute.toString().padLeft(2, '0')}"
        ":${second.toString().padLeft(2, '0')}";
  }

  //SQL (YYYY-MM-DD) only Data
  String toSqlDateOnly() {
    return "${year.toString().padLeft(4, '0')}"
        "-${month.toString().padLeft(2, '0')}"
        "-${day.toString().padLeft(2, '0')}";
  }

  //SQL (HH:MM:SS)
  String toSqlTimeOnly() {
    return "${hour.toString().padLeft(2, '0')}"
        ":${minute.toString().padLeft(2, '0')}"
        ":${second.toString().padLeft(2, '0')}";
  }

  /// [OUTPUT EXAMPLE] July 02, 1996
  String toDateView() {
    return DateFormat.yMMMMd(locale()).format(this).toString();
  }

  /// [OUTPUT EXAMPLE] Saturday, March 11 2023
  String toDayDateView() {
    return DateFormat.yMMMMEEEEd(locale()).format(this).toString();
  }

  /// [OUTPUT EXAMPLE] 12 am
  String toTimeView() {
    return DateFormat.jm(locale()).format(this).toString();
  }

  /// [OUTPUT EXAMPLE] Saturday, 12 am
  String toDayTimeView() {
    return DateFormat('EEEE hh:mm a', locale()).format(this).toString();
  }

  /// [OUTPUT EXAMPLE] July 02, 1996 | 12 am
  String toDateTimeView() {
    return DateFormat('d MMMM y - hh:mm a', locale()).format(this).toString();
  }

  /// [OUTPUT EXAMPLE] July 02, 1996 | Saturday
  String toDateDateView() {
    return DateFormat('EEEE - d MMMM y', locale()).format(this).toString();
  }

  /// [OUTPUT EXAMPLE] July 1996
  String toMonthYearView() {
    return DateFormat('MMMM y', locale()).format(this).toString();
  }

  /// [OUTPUT EXAMPLE] 12 : 30 : 00
  TimeOfDay toTimeOfDay() {
    return TimeOfDay.fromDateTime(this);
  }

  /// [OUTPUT EXAMPLE] Saturday
  String toDayOnly({bool withLocale = true}) {
    return DateFormat('EEEE', withLocale ? locale() : null)
        .format(this)
        .toString();
  }

  ///input format: 2021-12-30 or 2021-12-30 23:00:00
  ///output: 30 december, 2021
  String fullDate({bool hideCurrentYear = false, bool enableNaming = false}) {
    if (hideCurrentYear &&
        DateFormat.y(locale()).format(this) ==
            DateFormat.y(locale()).format(DateTime.now())) {
      return DateFormat.MMMd(locale()).format(this).toString();
    }

    return DateFormat.yMMMMd(locale()).format(this).toString();
  }

}