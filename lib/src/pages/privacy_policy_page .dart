import 'package:flutter/material.dart';
import '../helpers/general_helper.dart';
import '../utils/assets.dart';
import '../widgets/custom_app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        appTitle: trans().policies,
        icon: arrowBackIcon,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            trans().privacy_policy,
            textDirection: Directionality.of(context),
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

