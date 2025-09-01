import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../sheetes/language_bottom_sheet.dart';
import '../sheetes/logout_bottom_sheet.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import '../utils/theme.dart';
import '../widgets/display_mode_toggle.dart';
import '../widgets/mune_item_widget.dart';
import '../widgets/social_links_widget.dart';
import 'privacy_policy_page .dart';
import '../sheetes/support_bottom_sheet.dart';
import 'user_profile_page.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userProvider.notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).data;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final toggleButton = buildDisplayModeToggle(ref, context);

    // final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          trans().persons,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: colorScheme.secondary),
        leading: Directionality.of(context) == TextDirection.rtl
            ? toggleButton
            : null,
        actions: Directionality.of(context) == TextDirection.ltr
            ? [toggleButton]
            : null,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Insets.s12),
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              Directionality(
                textDirection: Directionality.of(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: S.r(40),
                      backgroundColor: colorScheme.surfaceVariant,
                      backgroundImage: (user?.media.isNotEmpty ?? false)
                          ? NetworkImage(user!.media.first.original_url)
                          : AssetImage(defaultAvatar) as ImageProvider,
                    ),
                    Gaps.w12,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? "User",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.secondary,
                          ),
                        ),
                        Gaps.h8,
                        Text(
                          user?.email ?? "user@mybooking.com",
                          style: TextStyle(
                            fontSize: TFont.s12,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gaps.h15,
              const Divider(),
              Gaps.h6,
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildMenuCard(
                    theme,
                    MenuItem(
                      title: trans().personal_data,
                      subtitle: trans().personal_data_desc,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserProfilePage(),
                          ),
                        );
                      },
                      icon: userCircleIcon,
                    ),
                  ),
                  _buildMenuCard(
                    theme,
                    MenuItem(
                      title: trans().settings,
                      subtitle: trans().settings_desc,
                      icon: cogIcon,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(S.r(20)),
                            ),
                          ),
                          backgroundColor: colorScheme.surface,
                          isScrollControlled: true,
                          builder: (context) => const LanguageBottomSheet(),
                        );
                      },
                    ),
                  ),
                  _buildMenuCard(
                    theme,
                    MenuItem(
                      title: trans().policies,
                      subtitle: trans().policies_desc,
                      icon: bookOpenIcon,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildMenuCard(
                    theme,
                    MenuItem(
                      title: trans().support,
                      subtitle: trans().support_desc,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(S.r(20)),
                            ),
                          ),
                          backgroundColor: colorScheme.surface,
                          isScrollControlled: true,
                          builder: (context) => const SupportBottomSheet(),
                        );
                      },
                      icon: headSetIcon,
                    ),
                  ),
                  _buildMenuCard(
                    theme,
                    MenuItem(
                        title: trans().list_your_facility,
                        subtitle: trans().promote_your_facility,
                        icon: showIcon,
                        onPressed: () async {
                          final uri = Uri.parse('https://bookings-guide.com');

                          // حاول أولًا بمتصفح خارجي
                          final launchedExternally = await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );

                          if (!launchedExternally) {
                            // جرّب فتحه داخل التطبيق كحل احتياطي
                            final launchedInApp = await launchUrl(
                              uri,
                              mode: LaunchMode
                                  .inAppBrowserView, // أو LaunchMode.inAppWebView
                            );

                            if (!launchedInApp) {
                              // أظهر رسالة مناسبة بدل الرمي
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'لا يمكن فتح الرابط على هذا الجهاز')),
                                );
                              }
                            }
                          }
                        }),
                  ),
                  _buildMenuCard(
                    theme,
                    MenuItem(
                      title: trans().logout,
                      subtitle: trans().logout_desc,
                      onPressed: () => showLogoutBottomSheet(context, ref),
                      icon: singInIcon,
                    ),
                  ),
                ],
              ),
              Gaps.h20,
              _buildMenuCard(
                theme,
                Padding(
                  padding: EdgeInsets.all(Insets.m16),
                  child: Column(
                    children: [
                      Image.asset(
                        mybooking,
                        width: S.w(150),
                        height: S.h(40),
                        fit: BoxFit.contain,
                      ),
                      Gaps.h15,
                      const SocialLinksWidget(),
                      Gaps.h15,
                      TextButton.icon(
                        onPressed: () async {
                          final shareText =
                              '${trans().share_app_message}📲 https://play.google.com/store/apps/details?id=com.mybooking';
                          await Share.share(
                            shareText,
                            subject: trans().share_subject,
                          );
                        },
                        icon: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [CustomTheme.color1, CustomTheme.color4],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Icon(shareIcon, color: Colors.white),
                        ),
                        label: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [CustomTheme.color1, CustomTheme.color4],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            trans().share_app,
                            style: TextStyle(
                              fontSize: TFont.m14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.h20,
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildMenuCard(ThemeData theme, Widget child) {
  return Card(
    color: theme.colorScheme.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: Corners.md15,
    ),
    margin: EdgeInsets.symmetric(
      vertical: Insets.xs8,
      horizontal: Insets.xs8,
    ),
    child: child,
  );
}
