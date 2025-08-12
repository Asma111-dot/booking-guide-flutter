import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final connectivityProvider =
StreamProvider<List<ConnectivityResult>>((ref) async* {
  final initial = await Connectivity().checkConnectivity();
  yield initial;
  yield* Connectivity().onConnectivityChanged;
});

final isOfflineProvider = Provider<bool>((ref) {
  final asyncList = ref.watch(connectivityProvider);

  return asyncList.when(
    data: (list) {
      final online = list.any((e) =>
      e == ConnectivityResult.wifi ||
          e == ConnectivityResult.mobile ||
          e == ConnectivityResult.ethernet);
      return !online;
    },
    loading: () => true,
    error: (_, __) => true,
  );
});
