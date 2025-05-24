import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/public/settings_provider.dart';
import '../utils/theme.dart';

class LanguageBottomSheet extends ConsumerWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

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
              color: CustomTheme.color2,
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
          ),
          const SizedBox(height: 10),
          _buildLanguageOption(
            context,
            ref,
            label: 'English',
            value: 'en',
            selected: settings.languageCode == 'en',
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
      }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ref.read(settingsProvider.notifier).setLanguageCode(value);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: CustomTheme.color2.withOpacity(0.1),
        highlightColor: CustomTheme.color2.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? CustomTheme.color2 : Colors.black,
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: CustomTheme.color2),
            ],
          ),
        ),
      ),
    );
  }
}
