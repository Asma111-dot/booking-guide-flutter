import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../sheetes/logout_bottom_sheet.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/mune_item_widget.dart';
import '../widgets/social_links_widget.dart';
import 'privacy_policy_page .dart';
import '../sheetes/support_bottom_sheet.dart';
import 'settings_page.dart';
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

    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          trans().persons,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: CustomTheme.color2,
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: CustomTheme.color2),
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        // ],
      ),
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: (user?.media.isNotEmpty ?? false)
                          ? NetworkImage(user!.media.first.original_url)
                          : AssetImage(defaultAvatar) as ImageProvider,
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? "User",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? "user@myBooking.com",
                          style: const TextStyle(
                            fontSize: 14,
                            color: CustomTheme.color3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildMenuCard(
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
                      icon: LineAwesomeIcons.user_circle,
                    ),
                  ),
                  // _buildMenuCard(
                  //   MenuItem(
                  //     title: trans().language,
                  //     subtitle: trans().language_desc,
                  //     onPressed: () {},
                  //     icon: LineAwesomeIcons.language_solid,
                  //   ),
                  // ),
                  _buildMenuCard(
                    MenuItem(
                      title: trans().settings,
                      subtitle: trans().settings_desc,
                      icon: LineAwesomeIcons.cog_solid,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildMenuCard(
                    MenuItem(
                      title: trans().policies,
                      subtitle: trans().policies_desc,
                      icon: LineAwesomeIcons.book_open_solid,
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
                    MenuItem(
                      title: trans().support,
                      subtitle: trans().support_desc,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          backgroundColor: Colors.grey.shade100,
                          isScrollControlled: true,
                          builder: (context) => const SupportBottomSheet(),
                        );
                      },
                      icon: LineAwesomeIcons.headset_solid,
                    ),
                  ),
                  _buildMenuCard(
                    MenuItem(
                      title: trans().logout,
                      subtitle: trans().logout_desc,
                      onPressed: () => showLogoutBottomSheet(context, ref),
                      icon: LineAwesomeIcons.sign_in_alt_solid,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildMenuCard(
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Image.asset(
                        myBooking,
                        width: 150,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      const SocialLinksWidget(),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () async {
                          final shareText =
                              '${trans().share_app_message}📲 https://play.google.com/store/apps/details?id=com.mybooking';
                          await Share.share(
                            shareText,
                            subject: trans().share_subject,
                          );
                        },
                        icon:
                            const Icon(Icons.share, color: CustomTheme.color2),
                        label: Text(
                          trans().share_app,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: CustomTheme.primaryColor,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: CustomTheme.color2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildMenuCard(Widget child) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
    child: child,
  );
}
