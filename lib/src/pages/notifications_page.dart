import 'package:booking_guide/src/extensions/date_formatting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../extensions/date_formatting.dart';
import '../helpers/general_helper.dart';
import '../providers/notification/notification_provider.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_widget.dart';
import '../models/notification_model.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(notificationsProvider.notifier).fetch();

      await ref.read(notificationsProvider.notifier).markAllAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationsState = ref.watch(notificationsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        appTitle: trans().notifications,
        icon: arrowBackIcon,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(notificationsProvider.notifier).fetch();
        },
        child: ViewWidget<List<NotificationModel>>(
          meta: notificationsState.meta,
          data: notificationsState.data,
          onLoading: () => const Center(child: CircularProgressIndicator()),
          onLoaded: (data) {
            if (data.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 200),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          notificationsIconSvg,
                          width: S.w(150),
                          height: S.h(150),
                        ),
                        Gaps.h12,
                        Text(
                          trans().noNotifications,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: TFont.l16,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Gaps.h8,
                        Text(
                          trans().noNotificationsHint,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: TFont.s12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: S.h(8)),
              itemCount: data.length,
                itemBuilder: (context, index) {
                  final n = data[index];
                  final createdAtStr = n.createdAt != null
                      ? n.createdAt.toLocal().toDateTimeView()
                      : '';

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: S.w(12), vertical: S.h(6)),
                    shape: RoundedRectangleBorder(borderRadius: Corners.md15),
                    child: ListTile(
                      leading: const Icon(notificationsIcon, color: CustomTheme.color1),
                      title: Text(
                        n.title ?? 'بدون عنوان',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(n.body ?? ''),
                      trailing: Text(
                        createdAtStr,
                        style: TextStyle(
                          fontSize: TFont.s12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                }
            );
          },
        ),
      ),
    );
  }
}
