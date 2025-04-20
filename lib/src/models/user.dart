import '../services/app_service.dart';
import '../storage/auth_storage.dart' as storage;

import 'media.dart';

class User {
  int id;
  String name;
  String email;
  String phone;
  String? password;
  String? address;

  List<Media> media;

  User.init()
      : id = 0,
        name = '',
        phone = '',
        email = '',
        address = '',
        media = [];

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.password,
    this.address,
    this.media = const [],
  });

  User.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'] ?? '',
        phone = jsonMap['phone'] ?? '',
        email = jsonMap['email'] ?? '',
        address = jsonMap['address'] ?? '',
        media = (jsonMap['media'] as List<dynamic>?)
                ?.map((item) => Media.fromJson(item))
                .toList() ??
            [];
  String? getAvatarUrl() {
    return media.isNotEmpty ? media.first.original_url : null;
  }

  Future<Map> toJson([String? verificationCode]) async {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["phone"] = phone;
    if (verificationCode != null) {
      map["sms_verification_code"] = verificationCode;
    }
    if (password != null) {
      map["password"] = password;
    }
    map['device_name'] = await deviceName();
    map["address"] = address;
    map["media"] = media.map((m) => m.toJson()).toList();
    return map;
  }

  static List<User> fromJsonList(List<dynamic> items) =>
      items.map((item) => User.fromJson(item)).toList();

  @override
  String toString() => toJson().toString();

  bool isLoggedIn() => storage.isLoggedIn();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
