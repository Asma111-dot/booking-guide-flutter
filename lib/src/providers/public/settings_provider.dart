import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/settings.dart' as model;
import '../../storage/settings_storage.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  @override
  model.Settings build() => getSettings();

  setLanguageCode(String locale) {
    state = state.copyWith(languageCode: locale);
    saveSettings(state);
  }

  setDisplayMode(model.DisplayMode displayMode) {
    state = state.copyWith(displayMode: displayMode);
    saveSettings(state);
  }

  setSkipUpdateDate() {
    state = state.copyWith(skipUpdateDate: DateTime.now());
    saveSettings(state);
  }

  setCompanyId(int id) {
    state = state.copyWith(selectedCompanyId: id);
    saveSettings(state);
  }
}
