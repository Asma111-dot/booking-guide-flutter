import 'package:booking_guide/src/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

import 'routes.dart';
import 'sizes.dart';

class CustomTheme {
  final bool isDark;
  CustomTheme({required this.isDark});

  String getFont(String languageCode) {
    switch (languageCode) {
      case 'ar': return 'GESS';
      case 'en': return 'Tajawal';
      default:   return 'Cairo';
    }
  }

  // ألوان أساسية
  static const Color color1 = Color(0xFFB114E9);
  static const Color color2 = Color(0xFF860EEE);
  static const Color color3 = Color(0xFF565BF2);
  static const Color color4 = Color(0xFF0DD7FC);

  static const Color primaryColor   = Color(0xFF150D33);
  static const Color secondaryColor = color3;
  static const Color tertiaryColor  = color4;
  static const Color accentColor    = color1;
  static const Color whiteColor     = Colors.white;

  static const Color shimmerBaseColor      = Color(0xffdcdcdc);
  static const Color shimmerHighlightColor = Color(0xffe6e6e6);

  static const double borderWidth      = 0.1;
  static const double fieldBorderWidth = 0.2;

  // احتفظنا بـ radius لأماكن تستخدمه مباشرة، لكن داخليًا استخدم Corners.lg
  static double get radius         => S.r(30);
  static double get minButtonSize  =>S.r(150);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [color1, color2, color3, color4],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color instagramColor = Color(0xFFE1306C); // اللون الرسمي
  static const Color facebookColor  = Color(0xFF1877F2);

  Color lightBackgroundColor() => isDark ? Colors.grey[900]! : const Color(0xffF0F0F0);
  Color successColor()         => isDark ? Colors.lightGreen : Colors.green;
  Color dangerColor()          => isDark ? Colors.redAccent : Colors.red;
  Color warningColor()         => const Color(0xFFEAA43F);
  Color progressColor()        => isDark ? Colors.blueAccent : const Color(0xff4A90E2);
  Color scaffoldColor()        => isDark ? const Color(0xff383838) : const Color(0xffF0F0F0);
  Color cardColor()            => isDark ? Colors.grey[900]! : Colors.white;
  Color fillColor()            => isDark ? Colors.grey[800]! : Colors.white;
  Color appBarColor()          => isDark ? Colors.grey[900]! : const Color(0xff4A90E2);
  Color borderColor()          => isDark ? Colors.grey[600]! : const Color(0xffE0E0E0);

  ThemeData fromSeed(String languageCode) => ThemeData(
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,
    fontFamily: getFont(languageCode),

    // ✅ نصوص ديناميكية
    textTheme: TextTheme(
      displayLarge:   TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(57), fontWeight: FontWeight.w400),
      displayMedium:  TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(45)),
      displaySmall:   TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(36)),

      headlineLarge:  TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(32), fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(28)),
      headlineSmall:  TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(24)),

      titleLarge:     TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(22), fontWeight: FontWeight.w600),
      titleMedium:    TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(16)),
      titleSmall:     TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(14)),

      bodyLarge:      TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(16), height: 1.4),
      bodyMedium:     TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(14), height: 1.4),
      bodySmall:      TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(12), height: 1.4),

      labelLarge:     TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(14), fontWeight: FontWeight.w600),
      labelMedium:    TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(12)),
      labelSmall:     TextStyle(fontFamily: getFont(languageCode), fontSize: S.sp(11)),
    ),

    // ✅ الألوان
    colorScheme: ColorScheme(
      brightness:  isDark ? Brightness.dark : Brightness.light,
      primary:     color2,
      onPrimary:   Colors.white,
      secondary:   color3,
      onSecondary: Colors.white,
      surface:     cardColor(),
      onSurface:   isDark ? Colors.white : primaryColor,
      error:       primaryColor,
      onError:     CustomTheme.color3,
      tertiary:    color4,
      onTertiary:  color1,
    ),

    scaffoldBackgroundColor: scaffoldColor(),
    cardColor: cardColor(),

    appBarTheme: AppBarTheme(
      color: appBarColor(),
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontFamily: getFont(languageCode),
        fontSize: S.sp(18),
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.white, // لأن اللون فوق محدد
      ),
    ),

    // ✅ حقول الإدخال
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: fillColor(),
      errorMaxLines: 5,
      hintStyle: TextStyle(fontSize: TFont.m14),
      contentPadding: EdgeInsets.symmetric(horizontal: Insets.m16, vertical: S.h(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: Corners.lg30,
        borderSide: BorderSide(width: fieldBorderWidth, color: borderColor()),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: Corners.lg30,
        borderSide: const BorderSide(width: fieldBorderWidth, color: primaryColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: Corners.lg30,
        borderSide: BorderSide(width: fieldBorderWidth, color: borderColor()),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: Corners.lg30,
        borderSide: BorderSide(width: fieldBorderWidth, color: borderColor()),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: Corners.lg30,
        borderSide: BorderSide(width: fieldBorderWidth, color: borderColor()),
      ),
    ),

    // ✅ تبويبات
    tabBarTheme: TabBarTheme(
      dividerColor: Colors.transparent,
      labelColor: secondaryColor,
      indicatorColor: secondaryColor,
      overlayColor: WidgetStateProperty.resolveWith(
            (state) => secondaryColor.withOpacity(0.10),
      ),
    ),

    // ✅ ListTile
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: Corners.lg30),
      contentPadding: EdgeInsets.symmetric(horizontal: Insets.m16, vertical: S.h(4)),
    ),

    // ✅ Buttons
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Sizes.btnM),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: Insets.m16, vertical: S.h(10)),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: Corners.lg30),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: TFont.l16, fontFamily: getFont(languageCode)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Sizes.btnM),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: Insets.m16, vertical: S.h(10)),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: Corners.lg30),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: TFont.l16, fontFamily: getFont(languageCode)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: Insets.m16, vertical: S.h(10)),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: Corners.lg30),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: TFont.l16, fontFamily: getFont(languageCode)),
        ),
      ),
    ),

    // ✅ FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: Corners.lg30),
      backgroundColor: navKey.currentContext == null
          ? null
          : Theme.of(navKey.currentContext!).colorScheme.secondary,
      foregroundColor: navKey.currentContext == null
          ? null
          : Theme.of(navKey.currentContext!).colorScheme.onSecondary,
    ),

    // ✅ Divider
    dividerTheme: DividerThemeData(
      thickness: 0.5,
      color: isDark ? Colors.grey : borderColor(),
    ),

    // ✅ Chip
    chipTheme: ChipThemeData(
      backgroundColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
      brightness: isDark ? Brightness.dark : Brightness.light,
      labelStyle: TextStyle(
        color: isDark ? Colors.grey[200] : Colors.grey[800],
        fontSize: TFont.s12,
        fontFamily: getFont(languageCode),
      ),
      secondaryLabelStyle: TextStyle(
        color: isDark ? primaryColor : Colors.white,
        fontSize: TFont.s12,
        fontFamily: getFont(languageCode),
      ),
      iconTheme: IconThemeData(
        size: Sizes.iconM20,
        color: isDark ? Colors.white : primaryColor,
      ),
      disabledColor: Colors.grey,
      checkmarkColor: isDark ? Colors.grey[300]! : Colors.grey[700]!,
      shape: RoundedRectangleBorder(borderRadius: Corners.pill100, side: BorderSide.none),
    ),

    // ✅ Checkbox
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(S.r(5))),
    ),

    // ✅ SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark ? color3 : primaryColor,
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: S.sp(14),
        fontFamily: getFont(languageCode),
      ),
    ),
  );
}

// ✅ Helpers
BoxDecoration boxDecoration(BuildContext context) {
  final isDark = Theme.of(context).isDark();
  final theme = CustomTheme(isDark: isDark);

  return BoxDecoration(
    color: theme.cardColor(),
    borderRadius: Corners.lg30,
    border: Border.all(
      color: theme.borderColor(),
      width: CustomTheme.borderWidth,
    ),
  );
}

BoxDecoration circleDecoration(BuildContext context) {
  return boxDecoration(context).copyWith(
    borderRadius: Corners.pill100,
  );
}

BorderRadius borderRadius()        => Corners.lg30;
BorderRadius buttonBorderRadius()  => Corners.pill100;
BorderRadius imageBorderRadius()   => Corners.pill100;

Color imagePlaceholderColor(BuildContext context) =>
    Theme.of(context).colorScheme.surface;
