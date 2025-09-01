import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/notification_model.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'notification_provider.g.dart';

@Riverpod(keepAlive: false)
class Notifications extends _$Notifications {
  @override
  Response<List<NotificationModel>> build() => const Response<List<NotificationModel>>(data: []);

  Future fetch() async {
    state = state.setLoading();

    String url = getNotificationsUrl();

    try {
      await request<List<dynamic>>(
        url: url,
        method: Method.get,
      ).then((value) {
        List<NotificationModel> notifications = value.data != null
            ? List<NotificationModel>.from(value.data!.map((n) => NotificationModel.fromJson(n)))
            : [];

        state = Response<List<NotificationModel>>(data: notifications, meta: value.meta).setLoaded();
      }).catchError((error) {
        state = state.setError(error.toString());
        print("❌ خطأ أثناء جلب الإشعارات: $error");
      });
    } catch (e, s) {
      print("⚠️ استثناء أثناء جلب الإشعارات: $e\n$s");
      state = state.setError(e.toString());
    }
  }

  /// ✅ دالة تحديد كل الإشعارات كمقروءة
  Future markAllAsRead() async {
    try {
      await request(
        url: markAllNotificationsReadUrl(),
        method: Method.post,
      );

      // عدّل الحالة محلياً بحيث يصير readAt = DateTime.now()
      state = Response<List<NotificationModel>>(
        data: state.data?.map((n) => NotificationModel(
          id: n.id,
          type: n.type,
          notifiableId: n.notifiableId,
          data: n.data,
          createdAt: n.createdAt,
          updatedAt: n.updatedAt,
          readAt: DateTime.now(), // ✅ تعيينها كمقروءة
        )).toList(),
        meta: state.meta,
      ).setLoaded();
    } catch (e) {
      print("❌ خطأ markAllAsRead: $e");
    }
  }
}
