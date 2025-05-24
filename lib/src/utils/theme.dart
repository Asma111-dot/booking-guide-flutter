import 'package:flutter/material.dart';
import 'package:booking_guide/src/extensions/theme_extension.dart';
import 'routes.dart';

class CustomTheme {
  final bool isDark;

  CustomTheme({required this.isDark});

  String getFont(String languageCode) => 'GESS';

  // return 'Tajawal';
  // return 'Cairo';

  // الثوابت العامة
  static const Color color1 = Color(0xFFB114E9);
  static const Color color2 = Color(0xFF860EEE);
  static const Color color3 = Color(0xFF565BF2);
  static const Color color4 = Color(0xFF0DD7FC);
  static const Color primaryColor = Color(0xFF140B2D);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color tertiaryColor = Color(0xFF2C3E50);
  static const Color fourthColor = Color(0xffF0F0F0);
  static const Color whiteColor = Colors.white;

  static const Color shimmerBaseColor = Color(0xffdcdcdc);
  static const Color shimmerHighlightColor = Color(0xffe6e6e6);

  static const double radius = 30;
  static const double borderWidth = 0.1;
  static const double fieldBorderWidth = 0.2;
  static const double minButtonSize = 150;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      color1, // #b114e9
      color2, // #860eee
      color3, // #565bf2
      color4, // #0dd7fc
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Color lightBackgroundColor() =>
      isDark ? Colors.grey[900]! : const Color(0xffF0F0F0);

  Color successColor() => isDark ? Colors.lightGreen : Colors.green;

  Color dangerColor() => isDark ? Colors.redAccent : Colors.red;

  Color warningColor() => const Color(0xFFEAA43F);

  Color progressColor() => isDark ? Colors.blueAccent : const Color(0xff4A90E2);

  scaffoldColor() => isDark ? Color(0xff383838) : Color(0xffF0F0F0);

  // Color scaffoldColor() => isDark ? const Color(0xff121212) : const Color(0xffF0F0F0);
  Color cardColor() => isDark ? Colors.grey[900]! : Colors.white;

  Color fillColor() => isDark ? Colors.grey[800]! : Colors.white;

  Color appBarColor() => isDark ? Colors.grey[900]! : const Color(0xff4A90E2);

  Color borderColor() => isDark ? Colors.grey[600]! : const Color(0xffE0E0E0);

  ThemeData fromSeed(String languageCode) => ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
        fontFamily: getFont(languageCode),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: primaryColor,
          secondary: secondaryColor,
          tertiary: tertiaryColor,
          primaryContainer: isDark ? Colors.grey[700] : Colors.grey[200],
        ),
        scaffoldBackgroundColor: scaffoldColor(),
        cardColor: cardColor(),
        appBarTheme: AppBarTheme(
          color: appBarColor(),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          fillColor: fillColor(),
          errorMaxLines: 5,
          hintStyle: const TextStyle(fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide:
                BorderSide(width: fieldBorderWidth, color: borderColor()),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide:
                const BorderSide(width: fieldBorderWidth, color: primaryColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide:
                BorderSide(width: fieldBorderWidth, color: borderColor()),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide:
                BorderSide(width: fieldBorderWidth, color: borderColor()),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide:
                BorderSide(width: fieldBorderWidth, color: borderColor()),
          ),
        ),
        tabBarTheme: TabBarTheme(
          dividerColor: Colors.transparent,
          labelColor: secondaryColor,
          indicatorColor: secondaryColor,
          overlayColor: WidgetStateProperty.resolveWith(
            (state) => secondaryColor.withValues(alpha: 26),
          ),
        ),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius)),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius)),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius)),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          backgroundColor: navKey.currentContext == null
              ? null
              : Theme.of(navKey.currentContext!).colorScheme.secondary,
          foregroundColor: navKey.currentContext == null
              ? null
              : Theme.of(navKey.currentContext!).colorScheme.onSecondary,
        ),
        dividerTheme: DividerThemeData(
          thickness: 0.5,
          color: isDark ? Colors.grey : borderColor(),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          brightness: isDark ? Brightness.dark : Brightness.light,
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[200] : Colors.grey[800],
            fontSize: 12,
            fontFamily: getFont(languageCode),
          ),
          secondaryLabelStyle: TextStyle(
            color: isDark ? Colors.black : Colors.white,
            fontSize: 12,
            fontFamily: getFont(languageCode),
          ),
          iconTheme: IconThemeData(
            color: isDark ? Colors.white : Colors.black,
          ),
          disabledColor: Colors.grey,
          checkmarkColor: isDark ? Colors.grey[300]! : Colors.grey[700]!,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide.none,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      );
}

BoxDecoration boxDecoration(BuildContext context) {
  final isDark = Theme.of(context).isDark();
  final theme = CustomTheme(isDark: isDark);

  return BoxDecoration(
    color: theme.cardColor(),
    borderRadius: BorderRadius.circular(CustomTheme.radius),
    border: Border.all(
      color: theme.borderColor(),
      width: CustomTheme.borderWidth,
    ),
  );
}

BoxDecoration circleDecoration(BuildContext context) {
  return boxDecoration(context).copyWith(
    borderRadius: BorderRadius.circular(100),
  );
}

BorderRadius borderRadius() => BorderRadius.circular(CustomTheme.radius);

BorderRadius buttonBorderRadius() => BorderRadius.circular(100);

BorderRadius imageBorderRadius() => BorderRadius.circular(100);

Color imagePlaceholderColor(BuildContext context) =>
    Theme.of(context).colorScheme.surface;
