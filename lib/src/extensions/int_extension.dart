import 'package:intl/intl.dart';

import '../utils/global.dart';

//

locale() => globalRef.read(settingsProvider).languageCode;

extension IntExtension on int {

  /// [INPUT EXAMPLE] 2
  /// [OUTPUT EXAMPLE] February
  String toMonth() {
    return DateFormat('MMMM',locale()).format(DateTime(DateTime.now().year, this)).toString();
  }

  String? notZero() {
    if(this <= 0) return null;
    return toString();
  }
}