import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/notification/notification_provider.dart';
import '../utils/assets.dart';
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
    Future.microtask(() {
      ref.read(notificationsProvider.notifier).fetch();
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
          showEmpty: true,
          showError: true,
          onEmpty: () => Center(
            child: Text(
              'لا توجد إشعارات حالية',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          onLoading: () => const Center(child: CircularProgressIndicator()),
          onLoaded: (data) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final notification = data[index];
                final title = notification.title ?? 'بدون عنوان';
                final body = notification.body ?? '';
                final createdAt = notification.createdAt != null
                    ? notification.createdAt!.toLocal().toString().substring(0, 16)
                    : '';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.notifications, color: CustomTheme.color1),
                    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(body),
                    trailing: Text(
                      createdAt,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    onTap: () {
                      // ✅ يمكنك إضافة فتح تفاصيل الإشعار هنا
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
