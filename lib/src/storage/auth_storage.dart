import '../models/user.dart';
import '../services/hive_service.dart';

String _authBox = 'auth_user';

String _tokenKey = 'token';
String _idKey = 'id';
String _nameKey = 'name';
String _emailKey = 'email';
String _phoneKey = 'phone';
String _avatar = 'avatar';

Future open() async => await openBox(_authBox);

User? currentUser() {
  try {
    return User(
      id: box(_authBox).get(_idKey),
      name: box(_authBox).get(_nameKey),
      phone: box(_authBox).get(_phoneKey),
      email: box(_authBox).get(_emailKey),
      media: box(_authBox).get(_avatar),
    );
  }
  catch(e) {
    return null;
  }
}

Future saveCurrentProfile(User user) async {
  await box(_authBox).put(_idKey, user.id);
  await box(_authBox).put(_nameKey, user.name);
  await box(_authBox).put(_phoneKey, user.phone);
  await box(_authBox).put(_emailKey, user.email);
  await box(_authBox).put(_avatar, user.media);
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