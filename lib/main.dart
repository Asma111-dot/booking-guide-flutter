import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';

import 'l10n/app_localizations.dart';
import 'src/enums/display_mode.dart';
import 'src/providers/notification/notification_provider.dart';
import 'src/providers/public/settings_provider.dart';
import 'src/services/connectivity_service.dart';
import 'src/services/hive_service.dart' as hive_service;
import 'src/utils/global.dart';
import 'src/utils/routes.dart';
import 'src/utils/theme.dart';

Future<void> initFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // iOS فقط يحتاج صلاحية
  await messaging.requestPermission();

  // الاشتراك في topic "all"
  await messaging.subscribeToTopic('all');
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 رسالة واردة في الخلفية: ${message.notification?.title}');
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initFCM();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await globalRef.read(notificationsProvider.notifier).fetch();

    // (اختياري) أظهر Toast سريع
    // BotToast.showText(text: message.notification?.title ?? 'New notification');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    await globalRef.read(notificationsProvider.notifier).fetch();
  });

  final initialMsg = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMsg != null) {
    await globalRef.read(notificationsProvider.notifier).fetch();
  }

  // const secureStorage = FlutterSecureStorage();
  // await secureStorage.deleteAll(); // 🧹 امسح المفاتيح القديمة من التخزين الآمن

  await Hive.initFlutter();

  // await Hive.deleteBoxFromDisk('auth');
  // await Hive.deleteBoxFromDisk('settings');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // ✅ استقبال في الخلفية

  await hive_service.init();
  ConnectivityService.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812), // حجم التصميم الأساسي (مثلاً iPhone X)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => const ProviderScope(child: MyApp()),
    ),
  );
  // runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    globalRef = ref;
    final settings = ref.watch(settingsProvider);

    final customTheme = CustomTheme(isDark: settings.displayMode.isDark());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navKey,
      // ✅ دعم BotToast مع Directionality حسب اللغة
      builder: (context, child) {
        final isArabic = settings.languageCode == 'ar';
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: BotToastInit()(context, child),
        );
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      initialRoute: Routes.welcome,
      onGenerateRoute: Routes.generate,
      title: appName(settings.languageCode),
      locale: Locale(settings.languageCode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: customTheme.fromSeed(settings.languageCode),
      darkTheme: CustomTheme(isDark: true).fromSeed(settings.languageCode),
      themeMode: settings.displayMode == DisplayMode.dark
          ? ThemeMode.dark
          : settings.displayMode == DisplayMode.light
          ? ThemeMode.light
          : ThemeMode.system,
    );
  }
}
