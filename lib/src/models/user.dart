import 'dart:io';

import 'package:dio/dio.dart';

import '../services/app_service.dart';
import '../storage/auth_storage.dart' as storage;
import 'company.dart';

class User {

  int id;
  String name;
  String email;
  String phone;
  String? avatar;
  String? password;

  // Used locally
  File? uploadImage;

  User.init() :
        id = 0,
        name = '',
        phone = '',
        email = '';

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.avatar,
    this.password,
  }); //  String role;

  User.fromJson(Map<String, dynamic> jsonMap) :
        id = jsonMap['id'],
        name = jsonMap['name'] ?? '',
        phone = jsonMap['phone'] ?? '',
        email = jsonMap['email'] ?? '',
        avatar = jsonMap['avatar'];


  Future<Map> toJson([String? verificationCode]) async {
    var map =  <String, dynamic>{};
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["phone"] = phone;
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
    "avatar": uploadImage == null ? null : await MultipartFile.fromFile(uploadImage!.path),
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
