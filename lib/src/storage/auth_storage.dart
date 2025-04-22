import '../models/user.dart';
import '../models/media.dart';
import '../services/hive_service.dart';

String _authBox = 'auth_user';

String _tokenKey = 'token';
String _idKey = 'id';
String _nameKey = 'name';
String _emailKey = 'email';
String _phoneKey = 'phone';
String _avatar = 'avatar';
String _avatarId = 'avatar_id';
String _addressKey = 'address';

String _isFirstTimeKey = 'is_first_time';
String _isLoggedInKey = 'is_logged_in';

/// فتح صندوق التخزين
Future open() async => await openBox(_authBox);

/// استرجاع المستخدم الحالي
User? currentUser() {
  try {
    final avatarUrl = box(_authBox).get(_avatar);
    return User(
      id: box(_authBox).get(_idKey),
      name: box(_authBox).get(_nameKey),
      phone: box(_authBox).get(_phoneKey),
      email: box(_authBox).get(_emailKey),
      address: box(_authBox).get(_addressKey),
      media: avatarUrl != null && avatarUrl is String && avatarUrl.isNotEmpty
          ? [Media(original_url: avatarUrl, id: 1)]
          : [],
    );
  } catch (e) {
    return null;
  }
}

/// حفظ بيانات المستخدم بعد تسجيل الدخول
Future saveCurrentProfile(User user) async {
  // print("💾 Saving user: ${user.toJson()}"); // Debug
  await box(_authBox).put(_idKey, user.id);
  await box(_authBox).put(_nameKey, user.name);
  await box(_authBox).put(_phoneKey, user.phone);
  await box(_authBox).put(_emailKey, user.email);
  await box(_authBox).put(_addressKey, user.address);
  await box(_authBox).put(_avatar, user.media.isNotEmpty ? user.media.first.original_url : '');
  await box(_authBox).put(_avatarId, user.media.isNotEmpty ? user.media.first.id : null);

}

/// حذف بيانات المستخدم (أثناء تسجيل الخروج)
Future clearCurrentUser() async {
  await box(_authBox).clear();
}

/// حفظ التوكن
void setToken(String value) {
  box(_authBox).put(_tokenKey, value);
}

/// استرجاع التوكن
String? getToken() {
  return box(_authBox).get(_tokenKey);
}

/// التحقق إذا المستخدم الحالي مسجّل دخول
bool isLoggedIn() => currentUser() != null;

/// هل هذه أول مرة يفتح التطبيق؟
Future<bool> isFirstTime() async {
  return box(_authBox).get(_isFirstTimeKey, defaultValue: true);
}

/// تعيين أن التطبيق لم يعد أول مرة
Future<void> setFirstTimeFalse() async {
  await box(_authBox).put(_isFirstTimeKey, false);
}

/// حفظ حالة تسجيل الدخول (true/false)
Future<void> setLoggedIn(bool value) async {
  await box(_authBox).put(_isLoggedInKey, value);
}

/// فحص حالة تسجيل الدخول (تم تسجيل الدخول مسبقًا؟)
bool isUserLoggedIn() {
  return box(_authBox).get(_isLoggedInKey, defaultValue: false);
}

/// تسجيل الخروج الكامل (يمسح الحالة والبيانات)
Future<void> logout() async {
  await box(_authBox).put(_isLoggedInKey, false);
  await clearCurrentUser();
}
