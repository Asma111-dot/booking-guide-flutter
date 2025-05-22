import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/display_mode.dart' as model;
import '../providers/public/settings_provider.dart';
import '../utils/assets.dart';
import '../widgets/custom_app_bar.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          appTitle: trans().settings,
          icon: arrowBackIcon,
        ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(trans().selectLanguage, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: settings.languageCode,
              items: const [
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setLanguageCode(value);
                }
              },
            ),
            const SizedBox(height: 24),
            const Text("نمط العرض:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            DropdownButton<model.DisplayMode>(
              value: settings.displayMode,
              items:  [
                DropdownMenuItem(
                  value: model.DisplayMode.light,
                  child: Text(trans().lightMode),
                ),
                DropdownMenuItem(
                  value: model.DisplayMode.dark,
                  child: Text(trans().darkMode),
                ),
                DropdownMenuItem(
                  value: model.DisplayMode.systemDefault,
                  child: Text('حسب النظام'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setDisplayMode(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
