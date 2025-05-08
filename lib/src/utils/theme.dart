import 'package:booking_guide/src/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class CustomTheme {
  final bool isDark;

  CustomTheme({
    required this.isDark,
  });

  // String getFont(String languageCode) {
  //   return languageCode == 'ar' ? 'AraHamahAlFiddaa' : 'Unbounded';
  // }

  String getFont(String languageCode) {
    // return 'Cairo';
    return 'Tajawal';
  }


  static const Color color1 = Color(0xFFB114E9); // b114e9
  static const Color color2 = Color(0xFF860EEE); // 860eee
  static const Color color3 = Color(0xFF565BF2); // 565bf2
  static const Color color4 = Color(0xFF0DD7FC); // 0dd7fc
  static const Color primaryColor = Color(0xFF140B2D); // 140b2d (Primary)

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

  // Color.fromARGB(232, 17, 75, 151);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const tertiaryColor = Color(0xFF2C3E50); // Dark blue
  static const fourthColor = Color(0xffF0F0F0); // Light gray

  static const Color whiteColor = Colors.white; // Light gray color placeholderColor
  static const Color shimmerBaseColor =
      Color(0xffdcdcdc); // Slightly darker gray color
  static const Color shimmerHighlightColor =
      Color(0xffe6e6e6); // Light gray color for shimmer highlights

  static const double radius = 30;
  static const double borderWidth = 0.1;
  static const double fieldBorderWidth = 0.2;
  static const double minButtonSize = 150;

  Color successColor() => isDark ? Colors.lightGreen : Colors.green;

  Color dangerColor() => isDark ? Colors.redAccent : Colors.red;

  Color warningColor() => isDark ? Color(0xFFEAA43F) : Color(0xFFEAA43F);

  Color progressColor() => isDark ? Colors.blueAccent : Color(0xff4A90E2);

  scaffoldColor() => isDark ? Color(0xff383838) : Color(0xffF0F0F0);

  lightBackgroundColor() => isDark ? Color(0xff) : Color(0xff4A90E2);

  appBarColor() => isDark ? Colors.grey[900] : Color(0xff4A90E2);

  borderColor() => isDark ? Colors.grey[600] : Color(0xffE0E0E0);

  darkBackgroundColor() => isDark ? null : Colors.white;

  fillColor() => Colors.white;

  ThemeData fromSeed(String languageCode) => ThemeData(
        useMaterial3: true,
    fontFamily: getFont(languageCode),
        colorScheme: ColorScheme.fromSeed(
          brightness: isDark ? Brightness.dark : Brightness.light,
          seedColor: primaryColor,
          primary: isDark ? null : primaryColor,
          secondary: secondaryColor,
          onSecondary: Colors.white,
          primaryContainer: isDark ? Colors.grey[700] : Colors.grey[200],
          tertiary: tertiaryColor,
        ),
        tabBarTheme: TabBarTheme(
          dividerColor: Colors.transparent,
          labelColor: secondaryColor,
          indicatorColor: secondaryColor,
          overlayColor: WidgetStateProperty.resolveWith(
              (state) => secondaryColor.withValues(alpha: 0.1 * 255)),
        ),
        scaffoldBackgroundColor: scaffoldColor(),
        appBarTheme: AppBarTheme(
          color: appBarColor(),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
        ),
        listTileTheme: ListTileThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius(),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          errorMaxLines: 5,
          hintStyle: const TextStyle(fontSize: 14),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide:
                  BorderSide(width: fieldBorderWidth, color: borderColor())),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(
                  width: fieldBorderWidth, color: primaryColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide:
                  BorderSide(width: fieldBorderWidth, color: borderColor())),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide:
                  BorderSide(width: fieldBorderWidth, color: borderColor())),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(width: fieldBorderWidth)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.resolveWith((states) =>
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius))),
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
            shape: WidgetStateProperty.resolveWith((states) =>
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius))),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: borderRadius()),
          backgroundColor: navKey.currentContext == null
              ? null
              : Theme.of(navKey.currentContext!).colorScheme.secondary,
          foregroundColor: navKey.currentContext == null
              ? null
              : Theme.of(navKey.currentContext!).colorScheme.onSecondary,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        dividerTheme: DividerThemeData(
          thickness: 0.5,
          color: isDark ? null : borderColor(),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300]!,
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
          checkmarkColor: isDark ? Colors.grey[300] : Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
        ),
      );
}

Widget vSeparator(BuildContext context) => const SizedBox(height: 10);

BoxDecoration boxDecoration(BuildContext context) {
  var theme = CustomTheme(
    isDark: Theme.of(context).isDark(),
  );

  return BoxDecoration(
    color: theme.lightBackgroundColor(),
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
