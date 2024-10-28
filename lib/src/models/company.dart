import 'dart:io';

import 'package:dio/dio.dart';

import '../services/app_service.dart';
import '../storage/auth_storage.dart' as storage;

class Company {

  int id;
  String name;
  String? slogan;
  String? logo;
  String? cover;

  // Used locally
  bool selected = false;
  File? uploadLogoImage;
  File? uploadCoverImage;

  Company({
    required this.id,
    required this.name,
    this.slogan,
    this.logo,
    this.cover,
  });

  Company.fromJson(Map<String, dynamic> jsonMap) :
        id = jsonMap['id'],
        name = jsonMap['name'],
        slogan = jsonMap['slogan'],
        logo = jsonMap['logo'],
        cover = jsonMap['cover'];

  Future<Map> toJson([String? verificationCode]) async {
    var map =  <String, dynamic>{};
    map["id"] = id;
    map["slogan"] = slogan;
    map["name"] = name;
    map['device_name'] = await deviceName();
    return map;
  }

  static List<Company> fromJsonList(List<dynamic> items) =>
      items.map((item) => Company.fromJson(item)).toList();

  @override
  String toString() => toJson().toString();

  bool isLoggedIn() => storage.isLoggedIn();

  Future<FormData> toLogoJson() async => FormData.fromMap({
    "logo": uploadLogoImage == null ? null : await MultipartFile.fromFile(uploadLogoImage!.path),
  });

  DateTime startDateTime() => DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    8,
  );

  DateTime endDateTime() => DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    15,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Company &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
