import '../helpers/general_helper.dart';
import '../models/settings.dart';
import '../services/hive_service.dart';

var _settingsBox = 'settings';
var forceUpdateKey = 'forceUpdate';
var minimumVersionKey = 'minimumVersion';
var termsOfUseKey = 'termsOfUse';
var privacyKey = 'privacyPolicy';
var skipUpdateTimeout = 'skipUpdateTimeout';

// managed locally
var selectedCompanyId = 'selectedCompanyId';
var skipUpdateDate = 'skipUpdateDate';
var languageCode = 'languageCode';
var displayMode = 'displayMode';

Future open() async => await openBox(_settingsBox);

Future clearSettings() async => await box(_settingsBox).clear();

Settings getSettings() {
  try {
    return Settings(
      forceUpdate: box(_settingsBox).get(forceUpdateKey, defaultValue: false),
      minimumVersion: box(_settingsBox).get(minimumVersionKey, defaultValue: 1),
      termsOfUse: box(_settingsBox).get(termsOfUseKey, defaultValue: ''),
      privacy: box(_settingsBox).get(privacyKey, defaultValue: ''),
      selectedCompanyId: box(_settingsBox).get(selectedCompanyId),
      skipUpdateTimeout: box(_settingsBox).get(skipUpdateTimeout, defaultValue: 24),
      skipUpdateDate: box(_settingsBox).get(skipUpdateDate),
      languageCode: box(_settingsBox).get(languageCode, defaultValue: 'ar' /*PlatformDispatcher.instance.locale.languageCode*/),
      displayMode: displayModeFromName(box(_settingsBox).get(displayMode, defaultValue: DisplayMode.light.name /*DisplayMode.systemDefault.name*/)),
    );
  }
  catch(e,stack) {
    catchError(e,stack);
    return const Settings.init();
  }
}

Future saveSettings(Settings settings) async {
  await box(_settingsBox).put(forceUpdateKey, settings.forceUpdate);
  await box(_settingsBox).put(minimumVersionKey, settings.minimumVersion);
  await box(_settingsBox).put(termsOfUseKey, settings.termsOfUse);
  await box(_settingsBox).put(privacyKey, settings.privacy);
  await box(_settingsBox).put(selectedCompanyId, settings.selectedCompanyId);
  await box(_settingsBox).put(skipUpdateTimeout, settings.skipUpdateTimeout);
  await box(_settingsBox).put(skipUpdateDate, settings.skipUpdateDate);
  await box(_settingsBox).put(languageCode, settings.languageCode);
  await box(_settingsBox).put(displayMode, settings.displayMode.name);
}
