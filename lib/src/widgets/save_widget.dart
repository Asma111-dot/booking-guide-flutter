import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// مزود حالة العناصر المحفوظة
final savedItemsProvider = StateProvider<List<int>>((ref) => []);

class SaveButtonWidget extends ConsumerStatefulWidget {
  final int itemId;
  final Color iconColor;

  const SaveButtonWidget({
    Key? key,
    required this.itemId,
    this.iconColor = Colors.deepPurple,
  }) : super(key: key);

  @override
  _SaveButtonWidgetState createState() => _SaveButtonWidgetState();
}

class _SaveButtonWidgetState extends ConsumerState<SaveButtonWidget> {
  bool isSaved(int itemId, List<int> savedItems) => savedItems.contains(itemId);

  @override
  Widget build(BuildContext context) {
    final savedItems = ref.watch(savedItemsProvider);

    return IconButton(
      icon: Icon(
        isSaved(widget.itemId, savedItems) ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: widget.iconColor,
      ),
      onPressed: () {
        setState(() {
          if (isSaved(widget.itemId, savedItems)) {
            ref.read(savedItemsProvider).remove(widget.itemId);
            print('تمت إزالة العنصر: ${widget.itemId}');
          } else {
            ref.read(savedItemsProvider).add(widget.itemId);
            print('تم حفظ العنصر: ${widget.itemId}');
          }
        });
      },
    );
  }
}
