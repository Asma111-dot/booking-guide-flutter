import '../models/user.dart';
import '../services/hive_service.dart';

String _authBox = 'auth_user';

String _tokenKey = 'token';
String _idKey = 'id';
String _nameKey = 'name';
String _nameEnKey = 'nameEn';
String _emailKey = 'email';
String _mobileKey = 'mobile';
String _profilePhotoKey = 'profilePhoto';

Future open() async => await openBox(_authBox);

User? currentUser() {
  try {
    return User(
      id: box(_authBox).get(_idKey),
      name: box(_authBox).get(_nameKey),
      nameEn: box(_authBox).get(_nameEnKey),
      mobile: box(_authBox).get(_mobileKey),
      email: box(_authBox).get(_emailKey),
      profilePhotoPath: box(_authBox).get(_profilePhotoKey),
    );
  }
  catch(e) {
    return null;
  }
}

Future saveCurrentProfile(User user) async {
  await box(_authBox).put(_idKey, user.id);
  await box(_authBox).put(_nameKey, user.name);
  await box(_authBox).put(_nameEnKey, user.nameEn);
  await box(_authBox).put(_mobileKey, user.mobile);
  await box(_authBox).put(_emailKey, user.email);
  await box(_authBox).put(_profilePhotoKey, user.profilePhotoPath);
}

Future clearCurrentUser() async {
  await box(_authBox).clear();
}

void setToken(String value) {
  box(_authBox).put(_tokenKey, value);
}

String? getToken() {
  return box(_authBox).get(_tokenKey);
}

bool isLoggedIn() => currentUser() != null;