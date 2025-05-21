import 'package:flutter/foundation.dart';

import '../enums/display_mode.dart';
import '../helpers/general_helper.dart';
import '../storage/settings_storage.dart';

export '../enums/display_mode.dart';

@immutable
class Settings {
  final bool forceUpdate;
  final int minimumVersion;
  final String termsOfUse;
  final String privacy;
  // In hours
  final int skipUpdateTimeout;

  /// Managed locally
  final int? selectedCompanyId;
  final DateTime? skipUpdateDate;
  final String languageCode;
  final DisplayMode displayMode;

  const Settings({
    required this.forceUpdate,
    required this.minimumVersion,
    required this.termsOfUse,
    required this.privacy,
    required this.skipUpdateTimeout,
    required this.selectedCompanyId,
    required this.skipUpdateDate,
    required this.languageCode,
    required this.displayMode,
  });

  const Settings.init()
      : forceUpdate = false,
        minimumVersion = 1,
        skipUpdateTimeout = 24,
        termsOfUse = '',
        privacy = '',
        selectedCompanyId = null,
        skipUpdateDate = null,
        languageCode =
        'ar' /*ui.PlatformDispatcher.instance.locale.languageCode*/,
        displayMode = DisplayMode.light /*DisplayMode.systemDefault*/;

  Settings.fromJson(Map<String, dynamic> map)
      : forceUpdate = isTrue(map['force_update']),
        minimumVersion = map['minimum_version'] ?? '1',
        skipUpdateTimeout = map['skip_update_timeout'] ?? 24,
        termsOfUse = map['terms_of_use'] ?? '',
        privacy = map['privacy_policy'] ?? '',
        selectedCompanyId = getSettings().selectedCompanyId,
        skipUpdateDate = getSettings().skipUpdateDate,
        languageCode = getSettings().languageCode,
        displayMode = getSettings().displayMode;

  static List<Settings> fromJsonList(List<Map<String, dynamic>> items) =>
      items.map((item) => Settings.fromJson(item)).toList();

  Settings copyWith({
    int? paginate,
    bool? forceUpdate,
    int? minimumVersion,
    String? termsOfUse,
    String? privacy,
    int? selectedCompanyId,
    int? skipUpdateTimeout,
    DateTime? skipUpdateDate,
    String? languageCode,
    DisplayMode? displayMode,
  }) {
    return Settings(
      forceUpdate: forceUpdate ?? this.forceUpdate,
      minimumVersion: minimumVersion ?? this.minimumVersion,
      termsOfUse: termsOfUse ?? this.termsOfUse,
      privacy: privacy ?? this.privacy,
      selectedCompanyId: selectedCompanyId ?? this.selectedCompanyId,
      skipUpdateTimeout: skipUpdateTimeout ?? this.skipUpdateTimeout,
      skipUpdateDate: skipUpdateDate ?? this.skipUpdateDate,
      languageCode: languageCode ?? this.languageCode,
      displayMode: displayMode ?? this.displayMode,
    );
  }

  bool showUpdate() {
    if (skipUpdateDate == null) return true;
    return DateTime.now().difference(skipUpdateDate!).inHours >
        skipUpdateTimeout;
  }

  bool isLatin() => ['en', 'ar'].contains(languageCode);
}
