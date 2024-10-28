import 'dart:io';

import 'package:dio/dio.dart';

import '../services/app_service.dart';
import '../storage/auth_storage.dart' as storage;
import 'company.dart';

class User {

  int id;
  String name;
  String nameEn;
  String email;
  String mobile;
  String? profilePhotoPath;
  String? password;
  List<Company> companies;
  String? token;

  // Used locally
  File? uploadImage;

  User.init() :
        id = 0,
        name = '',
        nameEn = '',
        mobile = '',
        email = '',
        companies = [];

  User({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.mobile,
    required this.email,
    this.profilePhotoPath,
    this.password,
    this.companies = const [],
  }); //  String role;

  User.fromJson(Map<String, dynamic> jsonMap) :
        id = jsonMap['id'],
        name = jsonMap['name'] ?? '',
        nameEn = jsonMap['name_en'] ?? '',
        mobile = jsonMap['mobile'] ?? '',
        email = jsonMap['email'] ?? '',
        profilePhotoPath = jsonMap['profile_photo_path'],
        token = jsonMap['token'],
        companies = jsonMap['companies'] == null
            ? []
            : Company.fromJsonList(jsonMap['companies']);

  Future<Map> toJson([String? verificationCode]) async {
    var map =  <String, dynamic>{};
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["name_en"] = nameEn;
    map["phone"] = mobile;
    if(verificationCode != null) {
      map["sms_verification_code"] = verificationCode;
    }
    if(password != null) {
      map["password"] = password;
    }
    map['device_name'] = await deviceName();
    return map;
  }

  static List<User> fromJsonList(List<dynamic> items) =>
      items.map((item) => User.fromJson(item)).toList();

  @override
  String toString() => toJson().toString();

  bool isLoggedIn() => storage.isLoggedIn();

  Future<FormData> toImageJson() async => FormData.fromMap({
    "profile_photo_path": uploadImage == null ? null : await MultipartFile.fromFile(uploadImage!.path),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
