
import 'package:collection/collection.dart';

enum Alert {success, error, warning, info}

Alert? fromAlertName(String? name) {
  try {
    if (name?.isEmpty ?? true) return null;
    return Alert.values.firstWhereOrNull((e) => e.name == name);
  } catch (e) {
    return null;
  }
}