import 'package:booking_guide/src/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/facility/favorites_facility_provider.dart';

class SaveButtonWidget extends ConsumerWidget {
  final int itemId;
  final Color iconColor;

  const SaveButtonWidget({
    Key? key,
    required this.itemId,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    bool isSaved = favorites.contains(itemId);

    return IconButton(
      icon: Icon(
        isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: isSaved ? CustomTheme.primaryColor : iconColor,
      ),
      onPressed: () {
        ref.read(favoritesProvider.notifier).toggleFavorite(itemId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isSaved ? 'تمت الإزالة من المفضلة' : 'تمت الإضافة إلى المفضلة'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
