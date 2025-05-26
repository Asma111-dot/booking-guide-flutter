import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/sort/sort_key_provider.dart';
import '../providers/sort/sorted_facilities_provider.dart';
import '../utils/assets.dart';

class SortButton extends ConsumerWidget {
  const SortButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortKey = ref.watch(sortKeyProvider);

    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => RotationTransition(turns: animation, child: child),
        child: Icon(
          sortKey == 'price' ? arrowdownIcon : arrowupIcon,
          key: ValueKey(sortKey),
        ),
      ),
      tooltip: sortKey == 'price' ? 'ترتيب من الأرخص' : 'ترتيب من الأغلى',
      onPressed: () async {
        final newSortKey = sortKey == 'price' ? '-price' : 'price';
        ref.read(sortKeyProvider.notifier).state = newSortKey;
        await ref.read(sortedFacilitiesProvider(newSortKey).notifier).fetchSortedFacilities();
      },
    );
  }
}
