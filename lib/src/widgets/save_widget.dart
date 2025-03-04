import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorite/favorite_provider.dart';
import '../storage/auth_storage.dart';
import '../utils/theme.dart';

class SaveButtonWidget extends ConsumerWidget {
  final int itemId;
  final Color iconColor;
  final int facilityTypeId;

  const SaveButtonWidget({
    Key? key,
    required this.itemId,
    this.iconColor = CustomTheme.primaryColor,
    required this.facilityTypeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isSaved = favorites.data?.any((facility) => facility.id == itemId) ?? false;

    return IconButton(
      icon: Icon(
        isSaved ? Icons.favorite : Icons.favorite_border,
        color: isSaved ? Colors.red : iconColor,
      ),
      onPressed: () async {
        final userId = currentUser()?.id;
        if (userId == null) return;

        final notifier = ref.read(favoritesProvider.notifier);

        if (isSaved) {
          await notifier.removeFavorite(userId, itemId);
        } else {
          await notifier.addFavorite(userId, itemId);
        }

        // إعادة تحميل البيانات لتحديث الواجهة
        ref.invalidate(favoritesProvider);
      },
    );
  }
}