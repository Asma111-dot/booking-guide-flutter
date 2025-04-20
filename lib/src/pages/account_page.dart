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
import '../widgets/privacy_policy_widget.dart';
import '../sheetes/support_bottom_sheet.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

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
                color: CustomTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
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
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? "user@example.com",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
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
                      onPressed: () {},
                      icon: LineAwesomeIcons.user_circle,
                    ),
                  ),
                  _buildMenuCard(
                    MenuItem(
                      title: trans().language,
                      subtitle: trans().language_desc,
                      onPressed: () {},
                      icon: LineAwesomeIcons.language_solid,
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
                          MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
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
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                        logoCoverImage,
                        width: 120,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(LineAwesomeIcons.instagram),
                            color: CustomTheme.primaryColor,
                            onPressed: () {
                              // رابط إنستغرام
                            },
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(LineAwesomeIcons.facebook),
                            color: CustomTheme.primaryColor,
                            onPressed: () {
                              // رابط فيسبوك
                            },
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(LineAwesomeIcons.twitter),
                            color: CustomTheme.primaryColor,
                            onPressed: () {
                              // رابط تيك توك
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          Share.share(
                            'حمّل تطبيقنا الآن عبر الرابط التالي:\nhttps://example.com/app-download',
                            subject: 'تطبيق رائع! جرّبه الآن 👇',
                          );
                        },
                        label: const Text('شارك التطبيق مع أصدقائك!'),
                        icon: const Icon(LineAwesomeIcons.paper_plane_solid),
                        style: TextButton.styleFrom(
                          foregroundColor: CustomTheme.primaryColor,
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
