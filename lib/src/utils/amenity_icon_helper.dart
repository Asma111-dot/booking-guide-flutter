import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AmenityIconHelper {
  static IconData getAmenityIcon(String name) {
    final lowerName = name.toLowerCase();

    // وحدات الإقامة
    if (lowerName.contains('مجالس')) return FontAwesomeIcons.couch;
    if (lowerName.contains('جناح')) return FontAwesomeIcons.personBooth;
    if (lowerName.contains('غرفة نوم عائلية')) return FontAwesomeIcons.peopleRoof;
    if (lowerName.contains('غرفة نوم')) return Icons.bed;
    if (lowerName.contains('غرفة بسريرين')) return FontAwesomeIcons.bed;
    if (lowerName.contains('عرسان')) return FontAwesomeIcons.ring;

    // خدمات الطعام
    if (lowerName.contains('كافيتيريا')) return FontAwesomeIcons.mugHot;
    if (lowerName.contains('مطبخ')) return Icons.kitchen;
    if (lowerName.contains('حمامات')) return FontAwesomeIcons.bath;
    if (lowerName.contains('مطعم')) return FontAwesomeIcons.utensils;
    if (lowerName.contains('بوفيه')) return FontAwesomeIcons.bowlFood;
    if (lowerName.contains('غرفة طعام')) return FontAwesomeIcons.utensils;

    // القاعات والفعاليات
    if (lowerName.contains('أفراح')) return FontAwesomeIcons.champagneGlasses;
    if (lowerName.contains('اجتماعات')) return FontAwesomeIcons.peopleGroup;
    if (lowerName.contains('مؤتمرات')) return FontAwesomeIcons.rankingStar;
    if (lowerName.contains('مسرح')) return FontAwesomeIcons.theaterMasks;
    if (lowerName.contains('متعددة الأغراض')) return FontAwesomeIcons.rankingStar;
    if (lowerName.contains('احتفالات')) return FontAwesomeIcons.cakeCandles;
    if (lowerName.contains('تدريب')) return FontAwesomeIcons.chalkboardUser;

    // المرافق الخارجية
    if (lowerName.contains('جلسة خارجية')) return FontAwesomeIcons.umbrellaBeach;
    if (lowerName.contains('حديقة أطفال')) return FontAwesomeIcons.children;
    if (lowerName.contains('حديقة')) return FontAwesomeIcons.seedling;
    if (lowerName.contains('ملعب')) return FontAwesomeIcons.futbol;
    if (lowerName.contains('سطح')) return FontAwesomeIcons.building;
    if (lowerName.contains('مسبح') && lowerName.contains('داخلي')) return FontAwesomeIcons.personSwimming;
    if (lowerName.contains('مسبح') && lowerName.contains('خارجي')) return FontAwesomeIcons.waterLadder;
    if (lowerName.contains('مسبح') && lowerName.contains('أطفال')) return FontAwesomeIcons.baby;
    if (lowerName.contains('شرفة') || lowerName.contains('بلكونة')) return FontAwesomeIcons.warehouse;

    // مواقف سيارات
    if (lowerName.contains('موقف سيارات خارجي')) return FontAwesomeIcons.carSide;
    if (lowerName.contains('موقف سيارات داخلي')) return FontAwesomeIcons.squareParking;

    // الاستقبال والخدمات
    if (lowerName.contains('استقبال')) return FontAwesomeIcons.bellConcierge;
    if (lowerName.contains('كونسيرج')) return FontAwesomeIcons.userTie;

    // وسائل الراحة من الصورة:
    if (lowerName.contains('كاميرا')) return Icons.videocam;
    if (lowerName.contains('تكييف مركزي')) return FontAwesomeIcons.fan;
    if (lowerName.contains('مكيف')) return Icons.ac_unit;
    if (lowerName.contains('كوفى شوب')) return FontAwesomeIcons.mugSaucer;
    if (lowerName.contains('حيوانات أليفة')) return FontAwesomeIcons.paw;
    if (lowerName.contains('سبا') || lowerName.contains('بخار')) return FontAwesomeIcons.spa;
    if (lowerName.contains('سينما')) return FontAwesomeIcons.film;
    if (lowerName.contains('تراس') || lowerName.contains('الأرآس')) return FontAwesomeIcons.umbrella;
    if (lowerName.contains('جاكوزي')) return FontAwesomeIcons.hotTubPerson;
    if (lowerName.contains('الشواء') || lowerName.contains('باربكيو')) return FontAwesomeIcons.fireBurner;
    if (lowerName.contains('بروجكتر')) return FontAwesomeIcons.video;
    if (lowerName.contains('wifi')) return Icons.wifi;
    if (lowerName.contains('tv')) return Icons.tv;
    if (lowerName.contains('مروحة')) return FontAwesomeIcons.fan;
    if (lowerName.contains('مراوح')) return FontAwesomeIcons.wind;
    if (lowerName.contains('غسالة صحون')) return FontAwesomeIcons.soap;
    if (lowerName.contains('غسالة ملابس')) return FontAwesomeIcons.shirt;
    if (lowerName.contains('مصعد')) return FontAwesomeIcons.arrowsUpDown;
    if (lowerName.contains('نافورة')) return FontAwesomeIcons.water;
    if (lowerName.contains('شلال')) return FontAwesomeIcons.water;
    if (lowerName.contains('اضاءة')) return FontAwesomeIcons.lightbulb;
    if (lowerName.contains('نظام تدفئة')) return FontAwesomeIcons.fireFlameCurved;
    if (lowerName.contains('مكان مخصص للتصوير')) return FontAwesomeIcons.cameraRetro;
    if (lowerName.contains('مسبح')) return FontAwesomeIcons.waterLadder;

    // fallback
    return FontAwesomeIcons.circleQuestion;
  }
}
