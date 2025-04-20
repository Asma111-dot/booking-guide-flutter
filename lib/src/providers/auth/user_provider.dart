import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/general_helper.dart';
import '../../helpers/notify_helper.dart';
import '../../models/response/response.dart';
import '../../models/user.dart' as model;
import '../../services/request_service.dart';
import '../../storage/auth_storage.dart';
import '../../utils/urls.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class User extends _$User {
  @override
  Response<model.User> build() => Response(data: model.User.init());

  Future fetch({bool force = false}) async {

    if(currentUser() == null) return;

    if(!force) {
      state = state.copyWith(data: currentUser()!);
      state = state.setFetchAll(true);
    }
    else {
      state = state.setLoading();
    }

    await request<model.User>(
      url: getUserUrl(currentUser()!.id),
      method: Method.get,
      //key: 'user'
    ).then((value) async {
      if(value.isLoaded()) {
        state = state.copyWith(data: value.data);
        saveUserLocally(value.data!);
      }

      if(!state.meta.fetchedAll) {
        state = state.copyWith(meta: value.meta);
      }
    });
  }

  Future updateUser(model.User user, {bool deleteImage = false}) async {

    showLoading();

    await request<model.User>(
      url: updateUserUrl(user.id),
      method: Method.post,
      body: await state.data!.toJson(),
    ).then((value) async {
      if(value.isLoaded()) {
        saveUserLocally(value.data!);
      }
      hideLoading();
    });
  }
//if to ues logout
  Future logout() async {
    showLoading();

    await request(
      url: logoutUrl(),
      method: Method.post,
      redirectOnPermissionDenied: true,
    ).then((value) async {
      if (value.isLoaded()) {
        // نضيف هذه السطرين
        await logout(); // من auth_storage.dart يمسح حالة الدخول والمستخدم
        clearAllLocalDataAndNavigate(); // يعيد التوجيه
      }
    }).whenComplete(() => hideLoading());
  }

  Future saveUserLocally(model.User user) async {
    state = state.setLoading();
    state = state.copyWith(data: user);
    await saveCurrentProfile(user);
    state = state.setLoaded();
  }

  Future deleteAccount() async {

    showLoading();

    await request(
      url: deleteUserUrl(currentUser()!.id),
      method: Method.delete,
    ).then((value) async {
      if(value.isLoaded()) {
        clearAllLocalDataAndNavigate();
      }
    }).whenComplete(() => hideLoading());
  }
}