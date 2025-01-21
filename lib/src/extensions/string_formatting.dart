import '../providers/public/settings_provider.dart';
import '../utils/global.dart';

locale() => globalRef.read(settingsProvider).languageCode;

/// Date is based on my sql format (2021-12-30)
extension StringFormatting on String? {
  String toStringAsAutoFixing() {
    try {
      if (this == null || this!.isEmpty) return '';

      if (this == '0.0') return '0';

      double value = double.parse(this!);
      int firstPart = int.parse(value.toString().split('.').first);

      // e.g. 2.0 / 2
      if (value / firstPart == 1) return value.toStringAsFixed(0);

      return value.toStringAsFixed(2).endsWith("0")
          ? value.toStringAsFixed(1)
          : value.toStringAsFixed(2);
    } catch (e) {
      return this ?? '';
    }
  }

  int toInt() {
    if (this?.isEmpty ?? true) return 0;
    return int.tryParse(this!) ?? 0;
  }

  /// First, Second, Third and Last Name
  Map<String, String> splitNameToFour() {
    if (this?.isEmpty ?? true) return {};

    List<String> nameParts = this!.trim().split(RegExp(r'\s+'));
    Map<String, String> result = {};

    if (nameParts.isNotEmpty) {
      result['first_name'] = nameParts[0];
      if (nameParts.length > 1) {
        result['second_name'] = nameParts[1];
      }
      if (nameParts.length > 2) {
        result['third_name'] = nameParts[2];
      }
      if (nameParts.length > 3) {
        result['last_name'] = nameParts.sublist(3).join(' ');
      }
    }

    return result;
  }

  /// First and Last Name
  Map<String, String> splitNameToTwo() {
    if (this?.isEmpty ?? true) return {};

    List<String> nameParts = this!.trim().split(RegExp(r'\s+'));
    Map<String, String> result = {};

    if (nameParts.isNotEmpty) {
      result['first_name'] = nameParts[0];
      if (nameParts.length > 1) {
        result['last_name'] = nameParts[1];
      }
    }

    return result;
  }

  /// time to 00:00 am
  DateTime? fromTimeToDateTime() {
    if (this == null || this!.isEmpty) return null;

    var items = this!.split(':');
    if (items.length != 3) return null;

    try {
      int hour = items[0].toInt();
      int minute = items[1].toInt();
      int second = items[2].toInt();

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59 || second < 0 || second > 59) {
        return null;
      }

      DateTime now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute, second);
    } catch (e) {
      return null;
    }
  }
}
