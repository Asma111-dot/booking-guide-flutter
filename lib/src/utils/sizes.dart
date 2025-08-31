// lib/src/utils/sizes.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// —— أدوات عامة بدون الحاجة لاستيراد ScreenUtil خارج هذا الملف ——
/// استخدم S.w(140), S.h(80), S.r(12) بدل 140.w, 80.h, 12.r في الصفحات.
abstract final class S {
  static double w(double v) => v.w;
  static double h(double v) => v.h;
  static double r(double v) => v.r;
  static double sp(double v) => v.sp;


  static SizedBox gapH(double v) => SizedBox(height: v.h);
  static SizedBox gapW(double v) => SizedBox(width: v.w);
}

/// 🔹 حجوم الخطوط
abstract final class TFont {
  static double get xxs8  => 8.sp;
  static double get xxs10  => 10.sp;
  static double get xs11 => 11.sp;
  static double get s12  => 12.sp;
  static double get m14  => 14.sp;
  static double get l16  => 16.sp;
  static double get xl18 => 18.sp;
  static double get x2_20 => 20.sp;
  static double get x3_24 => 24.sp;
  static double get x4_28 => 28.sp;
  static double get x5_32 => 32.sp;
}

/// 🔹 هوامش ومسافات
abstract final class Insets {
  static double get s3_4 => 4.w;
  static double get xxs6  => 6.w;
  static double get xs8  => 8.w;
  static double get s12   => 12.w;
  static double get m16   => 16.w;
  static double get l20   => 20.w;
  static double get xl24  => 24.w;
  static double get x2_32  => 32.w;
  static double get x3_40  => 40.w;
}

/// 🔹 حواف
abstract final class Corners {
  static BorderRadius get sm8   => BorderRadius.circular(8.r);
  static BorderRadius get md15   => BorderRadius.circular(15.r);
  static BorderRadius get lg30   => BorderRadius.circular(30.r);
  static BorderRadius get xlg50  => BorderRadius.circular(50.r);
  static BorderRadius get pill100 => BorderRadius.circular(100.r);
}

/// 🔹 قياسات عناصر
abstract final class Sizes {
  static Size get btnS  => Size(120.w, 40.h);
  static Size get btnM  => Size(160.w, 44.h);
  static Size get btnL  => Size(180.w, 52.h);
  static Size get btnXL => Size(220.w, 60.h);

  static double get iconS16  => 16.r;
  static double get iconS18  => 18.r;
  static double get iconM20  => 20.r;
  static double get iconL24  => 24.r;
  static double get iconL36  => 36.r;
  static double get iconXL28 => 28.r;

  static double get avatarS32  => 32.r;
  static double get avatarM48  => 48.r;
  static double get avatarL  => 72.r;
  static double get avatarXL => 100.r;
}

/// 🔹 فجوات جاهزة (اختياري)
abstract final class Gaps {
  static SizedBox get h4  => SizedBox(height: 4.h);
  static SizedBox get h6  => SizedBox(height: 6.h);
  static SizedBox get h8  => SizedBox(height: 8.h);
  static SizedBox get h12 => SizedBox(height: 12.h);
  static SizedBox get h15 => SizedBox(height: 15.h);
  static SizedBox get h20 => SizedBox(height: 20.h);
  static SizedBox get h24 => SizedBox(height: 24.h);
  static SizedBox get h30 => SizedBox(height: 30.h);

  static SizedBox get w4  => SizedBox(width: 4.w);
  static SizedBox get w8  => SizedBox(width: 8.w);
  static SizedBox get w12 => SizedBox(width: 12.w);
  static SizedBox get w16 => SizedBox(width: 16.w);
  static SizedBox get w20 => SizedBox(width: 20.w);
  static SizedBox get w24 => SizedBox(width: 24.w);
  static SizedBox get w30 => SizedBox(width: 30.w);
}

