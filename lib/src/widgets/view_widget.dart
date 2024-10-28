import 'package:flutter/material.dart';

class ViewWidget<T> extends StatelessWidget {
  final bool? meta;
  final T? data;
  final Future<void> Function()? refresh;
  final bool forceShowLoaded;
  final Widget Function(T data) onLoaded;

  const ViewWidget({
    Key? key,
    required this.meta,
    required this.data,
    required this.refresh,
    required this.forceShowLoaded,
    required this.onLoaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (meta == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (data == null && !forceShowLoaded) {
      return Center(child: Text('No data available'));
    }

    return RefreshIndicator(
      onRefresh: refresh ?? () async {},
      child: onLoaded(data!),
    );
  }
}
