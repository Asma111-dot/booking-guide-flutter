import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import 'hotels_page.dart';
import 'chalets_page.dart';

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ThemeMode.light;

});

final themeProvider = Provider<CustomTheme>((ref) {
  final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
  return CustomTheme(isDark: isDarkMode);
});

class FacilityTypesPage extends ConsumerWidget {
  const FacilityTypesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          trans().welcomeToBooking,
          style: TextStyle(
            color: CustomTheme.placeholderColor,
          ),
        ),
        backgroundColor: theme.appBarColor(),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.asset(
            logoCoverImage,
            height: 80,
          ),
          SizedBox(height: 20),
          Text(
            trans().chooseOne,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: CustomTheme.primaryColor,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 3 / 4,
              ),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HotelsPage()),
                    );
                  },
                  child: buildFacilityTypeCard(
                    context,
                    image: hotelImage,
                    title: trans().hotel,
                    theme: theme,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChaletsPage()),
                    );
                  },
                  child: buildFacilityTypeCard(
                    context,
                    image: chaletImage,
                    title: trans().chalet,
                    theme: theme,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildFacilityTypeCard(BuildContext context, {required String image, required String title, required CustomTheme theme}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.lightBackgroundColor(),
        border: Border.all(color: theme.borderColor(), width: CustomTheme.borderWidth),
        borderRadius: BorderRadius.circular(CustomTheme.radius),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(CustomTheme.radius)),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              title,
              style: TextStyle(
                color: CustomTheme.tertiaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
