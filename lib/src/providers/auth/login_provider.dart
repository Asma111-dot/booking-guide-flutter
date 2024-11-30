import 'package:booking_guide/src/providers/auth/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/response/response.dart';
import '../../models/user.dart' as model;
import '../../services/request_service.dart';
import '../../storage/auth_storage.dart';
import '../../utils/routes.dart';
import '../../utils/urls.dart';

part 'login_provider.g.dart';

@Riverpod(keepAlive: true)
class Login extends _$Login {
  @override
  Response<model.User> build() => Response(data: model.User.init());

  Future submit() async {
    state = state.setLoading();
    await request<model.User>(
      url: loginUrl(),
      method: Method.post,
      body: await state.data!.toJson(),
    ).then((value) async {
      state = state.copyWith(meta: value.meta);
      if(value.isLoaded()) {
        await onSuccessLogin(value);
      }
    });
  }

  Future onSuccessLogin(Response<model.User> value) async {
    setToken(value.meta.accessToken ?? "");
    ref.read(userProvider.notifier).saveUserLocally(value.data!);
    //navKey.currentState!.pushNamedAndRemoveUntil(Routes.customers, (r) => false);
    navKey.currentState?.pushNamedAndRemoveUntil(Routes.facilityTypes, (r) => false);

  }
}

