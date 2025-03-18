// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/favorite/favorite_provider.dart';
// import '../storage/auth_storage.dart';
//
// class SaveButtonWidget extends ConsumerWidget {
//   final int itemId;
//   final Color iconColor;
//   final int facilityTypeId;
//
//   const SaveButtonWidget({
//     Key? key,
//     required this.itemId,
//     this.iconColor = Colors.blue,
//     required this.facilityTypeId,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final favoriteNotifier = ref.read(favoritesProvider.notifier);
//     final bool isSaved = favoriteNotifier.isFavorite(itemId);
//
//     return IconButton(
//       icon: Icon(
//         isSaved ? Icons.favorite : Icons.favorite_border,
//         color: isSaved ? Colors.red : iconColor,
//       ),
//       onPressed: () async {
//         final userId = currentUser()?.id;
//         if (userId == null) return;
//
//         if (isSaved) {
//           await favoriteNotifier.removeFavorite(ref, userId, itemId);
//         } else {
//           await favoriteNotifier.addFavorite(ref, userId, itemId);
//         }
//       },
//     );
//   }
// }
