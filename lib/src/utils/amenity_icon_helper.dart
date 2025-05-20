import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AmenityIconHelper {
  static IconData getAmenityIcon(String name) {
    final lowerName = name.toLowerCase();

    // المرافق الشائعة
    if (lowerName.contains('wifi') || lowerName.contains('انترنت')) {
      return Icons.wifi;
    } else if (lowerName.contains('tv') || lowerName.contains('تلفاز') || lowerName.contains('شاشة')) {
      return Icons.tv;
    } else if (lowerName.contains('بروجكتر')) {
      return FontAwesomeIcons.video;
    } else if (lowerName.contains('مسبح') && lowerName.contains('كبار')) {
      return FontAwesomeIcons.personSwimming;
    } else if (lowerName.contains('مسبح') && lowerName.contains('اطفال')) {
      return FontAwesomeIcons.baby;
    } else if (lowerName.contains('مسبح')) {
      return Icons.pool;
    } else if (lowerName.contains('موقف')) {
      return Icons.local_parking;
    } else if (lowerName.contains('تكييف') || lowerName.contains('مكيف')) {
      return Icons.ac_unit;
    } else if (lowerName.contains('تدفئة') || lowerName.contains('heating')) {
      return Icons.fireplace;
    } else if (lowerName.contains('مطبخ')) {
      return Icons.kitchen;
    } else if (lowerName.contains('غسالة')) {
      return Icons.local_laundry_service;
    } else if (lowerName.contains('كاميرا') || lowerName.contains('مراقبة')) {
      return Icons.videocam;
    } else if (lowerName.contains('استيم') || lowerName.contains('بخار')) {
      return FontAwesomeIcons.spa;
    } else if (lowerName.contains('جاكوزي')) {
      return FontAwesomeIcons.hotTubPerson;
    } else if (lowerName.contains('نوم')) {
      return Icons.bed;
    } else if (lowerName.contains('جلوس') || lowerName.contains('مجالس')) {
      return FontAwesomeIcons.couch;
    } else if (lowerName.contains('حمام')) {
      return FontAwesomeIcons.bath;
    } else if (lowerName.contains('شواء') || lowerName.contains('grill')) {
      return FontAwesomeIcons.fireBurner;
    } else if (lowerName.contains('ملعب')) {
      return FontAwesomeIcons.futbol;
    } else if (lowerName.contains('سينما')) {
      return FontAwesomeIcons.film;
    } else if (lowerName.contains('بقالة')) {
      return FontAwesomeIcons.store;
    } else if ((lowerName.contains('طاولة') || lowerName.contains('تنس')) && lowerName.contains('كرة')) {
      return FontAwesomeIcons.tableTennisPaddleBall;
    } else if (lowerName.contains('قدم') || lowerName.contains('فوتبول')) {
      return FontAwesomeIcons.futbol;
    } else if (lowerName.contains('حيوان') || lowerName.contains('حيوانات')) {
      return FontAwesomeIcons.paw;
    } else if (lowerName.contains('شرفة') || lowerName.contains('بلكونة') || lowerName.contains('balcony')) {
      return FontAwesomeIcons.warehouse;
    } else if (lowerName.contains('حديقة')) {
      return FontAwesomeIcons.seedling;
    } else if (lowerName.contains('بلوتوث') || lowerName.contains('مكبر') || lowerName.contains('سماعة')) {
      return FontAwesomeIcons.volumeHigh;
    } else if (lowerName.contains('فلتر') || lowerName.contains('منقي') || lowerName.contains('filter')) {
      return FontAwesomeIcons.wind;

      // إضافات جديدة

      // وحدات إقامة
    } else if (lowerName.contains('جناح')) {
      return FontAwesomeIcons.personBooth;
    } else if (lowerName.contains('غرفة نوم عائلية')) {
      return FontAwesomeIcons.peopleRoof;
    } else if (lowerName.contains('غرفة بسريرين')) {
      return FontAwesomeIcons.bed;
    } else if (lowerName.contains('تجهّز العرسان')) {
      return FontAwesomeIcons.ring;
    }

    // خدمات الطعام
    else if (lowerName.contains('كافيتيريا')) {
      return FontAwesomeIcons.mugHot;
    } else if (lowerName.contains('مطعم')) {
      return FontAwesomeIcons.utensils;
    } else if (lowerName.contains('بوفيه')) {
      return FontAwesomeIcons.bowlFood;
    } else if (lowerName.contains('طعام')) {
      return FontAwesomeIcons.utensils;
    }

    // القاعات
    else if (lowerName.contains('أفراح')) {
      return FontAwesomeIcons.champagneGlasses;
    } else if (lowerName.contains('اجتماعات')) {
      return FontAwesomeIcons.peopleGroup;
    } else if (lowerName.contains('مؤتمرات')) {
      return FontAwesomeIcons.rankingStar;
    } else if (lowerName.contains('مسرح')) {
      return FontAwesomeIcons.theaterMasks;
    } else if (lowerName.contains('احتفالات')) {
      return FontAwesomeIcons.cakeCandles;
    } else if (lowerName.contains('تدريب')) {
      return FontAwesomeIcons.chalkboardUser;
    }

    // جلسات خارجية
    else if (lowerName.contains('جلسة خارجية')) {
      return FontAwesomeIcons.umbrellaBeach;
    } else if (lowerName.contains('سطح')) {
      return FontAwesomeIcons.building;
    }

    // مواقف سيارات
    else if (lowerName.contains('خارجي') && lowerName.contains('موقف')) {
      return FontAwesomeIcons.carSide;
    } else if (lowerName.contains('داخلي') && lowerName.contains('موقف')) {
      return FontAwesomeIcons.squareParking;
    }

    // استقبال
    else if (lowerName.contains('استقبال')) {
      return FontAwesomeIcons.bellConcierge;
    } else if (lowerName.contains('كونسيرج')) {
      return FontAwesomeIcons.userTie;
    }

    // افتراضية
    return FontAwesomeIcons.circleQuestion;
  }
}
