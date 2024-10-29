import 'package:flutter/material.dart';

import '../models/response/meta.dart';
import '../storage/auth_storage.dart';
import 'loading_widget.dart';
import 'error_message_widget.dart';
import 'unauthorized_widget.dart';

typedef DataCallback<T> = Widget Function(T data);
typedef Callback = Widget Function();

class ViewWidget<T> extends StatelessWidget {
  final Meta meta;
  final T? data;
  final DataCallback<T> onLoaded;
  final Callback? onEmpty;
  final Callback? onError;
  final Callback? onLoading;
  final Callback? onUnauthenticated;
  final VoidCallback? refresh;
  final double? height;
  final bool forceShowLoaded;
  final Widget? wrapper;
  final bool errorTextOnly;
  final Widget? headerWidget;
  final bool showError;
  final bool showEmpty;
  final bool requireLogin;

  const ViewWidget({super.key,
    this.data,
    required this.meta,
    required this.onLoaded,
    this.onLoading,
    this.onEmpty,
    this.onError,
    this.refresh,
    this.onUnauthenticated,
    this.height,
    this.forceShowLoaded = false,
    this.wrapper,
    this.errorTextOnly = false,
    this.headerWidget,
    this.showError = true,
    this.showEmpty = true,
    this.requireLogin = false,
  });

  @override
  Widget build(BuildContext context) {

    if(!isLoggedIn() && requireLogin) {
      return onUnauthenticated != null
          ? onUnauthenticated!()
          : const UnauthorizedWidget();
    }

    if(forceShowLoaded) {
      return onLoaded(data as T);
    }

    switch(meta.status) {
      case Status.empty:
        if(!showEmpty) return const SizedBox();

        return onEmpty != null ? onEmpty!() : ErrorMessageWidget(
          message: meta.message,
          height: height,
          isEmpty: true,
          textOnly: errorTextOnly,
          onTap: refresh,
          headerWidget: headerWidget,
        );
      case Status.error:
        if(!showError) return const SizedBox();

        return onError != null ? onError!() : ErrorMessageWidget(
          message: meta.message,
          onTap: refresh,
          height: height,
          textOnly: errorTextOnly,
          isEmpty: false,
          headerWidget: headerWidget,
        );
      case Status.loading:
        return onLoading != null ? onLoading!() : LoadingWidget(height: height,);
      case Status.loaded:
        if(data == null) return LoadingWidget(height: height,);
        return onLoaded(data as T);
      default:
        return onLoading != null ? onLoading!() : LoadingWidget(height: height,);
    }
  }
}
