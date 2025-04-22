import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/general_helper.dart';
import '../../helpers/notify_helper.dart';
import '../../models/response/meta.dart';
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

  // Future<void> updateUser(model.User user) async {
  //   showLoading();
  //
  //   try {
  //     final result = await request<model.User>(
  //       url: updateUserUrl(),
  //       method: Method.put,
  //       body: await user.toJson(), // <-- هنا التعديل
  //     );
  //
  //     if (result.isLoaded()) {
  //       saveUserLocally(result.data!); // حفظ البيانات الجديدة محليًا
  //       state = Response(data: result.data!, meta: result.meta); // تحديث حالة Riverpod
  //     }
  //   } catch (e) {
  //     // يمكنك عرض رسالة خطأ هنا
  //   } finally {
  //     hideLoading();
  //   }
  // }


  Future<void> updateUser(model.User user, File? avatar) async {
    showLoading();

    final result = await request<model.User>(
      url: updateUserUrl(),
      method: Method.post, // ⚠️ إرسال كـ POST لكن ...
      isMultipart: true,
      file: avatar,
      fileFieldName: 'avatar',
      fields: {
        '_method': 'PUT', // ✅ Laravel will treat this as PUT
        'name': user.name,
        'email': user.email,
        'address': user.address ?? '',
      },
    );

    if (result.isLoaded()) {
      saveUserLocally(result.data!);
      state = Response(data: result.data!, meta: result.meta);
    }

    hideLoading();
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
        await logout();
        clearAllLocalDataAndNavigate();
      }
    }).whenComplete(() => hideLoading());
  }


  Future saveUserLocally(model.User user) async {
    state = state.setLoading();
    state = state.copyWith(data: user);
    await saveCurrentProfile(user);
    // print("📦 Hive content after save:");
    // print(box('auth_user').toMap());
    state = state.setLoaded();
  }

  Future<void> loadUserFromStorage() async {
    await open();
    // print("📦 Hive عند الفتح: ${box('auth_user').toMap()}");
    final user = currentUser();
    // debugPrint("🔁 Trying to load user: $user");
    if (user != null) {
      state = state.copyWith(data: user, meta: Meta(status: Status.loaded));
    } else {
      // debugPrint("❌ No user found in storage.");
    }
  }


  Future<void> deleteAccount(BuildContext context) async {
    showLoading();

    try {
      final result = await request(
        url: deleteUserUrl(),
        method: Method.delete,
      );

      if (result.isLoaded()) {
        await logout();
        clearAllLocalDataAndNavigate();

        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      debugPrint("❌ Failed to delete account: $e");
    } finally {
      hideLoading();
    }
  }

}