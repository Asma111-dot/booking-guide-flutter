import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/public/settings_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';

class LanguageBottomSheet extends ConsumerWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            trans().selectLanguage,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildLanguageOption(
            context,
            ref,
            label: 'العربية',
            value: 'ar',
            selected: settings.languageCode == 'ar',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 10),
          _buildLanguageOption(
            context,
            ref,
            label: 'English',
            value: 'en',
            selected: settings.languageCode == 'en',
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context,
      WidgetRef ref, {
        required String label,
        required String value,
        required bool selected,
        required ColorScheme colorScheme,
      }) {
    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ref.read(settingsProvider.notifier).setLanguageCode(value);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: colorScheme.primary.withOpacity(0.1),
        highlightColor: colorScheme.primary.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
              if (selected)
                Icon(checkIcon, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
