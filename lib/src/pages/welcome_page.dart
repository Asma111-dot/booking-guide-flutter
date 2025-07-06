import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../providers/auth/user_provider.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), _navigateToNextScreen);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProvider.notifier).loadUserFromStorage();
      initFCM(); // ✅ استدعاء FCM هنا بعد التأكد من أن السياق جاهز
    });
  }

  Future<void> _navigateToNextScreen() async {
    final firstTime = await isFirstTime();
    final loggedIn = isUserLoggedIn();

    if (firstTime || !loggedIn) {
      await setFirstTimeFalse();
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.navigationMenu,
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(mybooking),
          ),
        ],
      ),
    );
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void initFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // طلب الصلاحيات
  await messaging.requestPermission();

  String? token = await messaging.getToken();
  print('🔑 FCM Token: $token');

  // إعداد الإشعارات المحلية
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📲 إشعار Foreground: ${message.notification?.title}');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel_id',
            'Default Channel',
            channelDescription: 'Channel for FCM notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📲 تم فتح التطبيق من الإشعار');
    // يمكنك إضافة التوجيه لصفحة هنا
  });
}
