import 'package:flutter/material.dart';
import '../enums/payment_method.dart';
import '../utils/assets.dart';

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.selected,
    this.disabled = false,
  });

  final PaymentMethod method;
  final bool selected;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(fontWeight: FontWeight.bold);

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceVariant.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? cs.primary : cs.outline,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                method.image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(NotImageIcon, color: cs.error, size: 40),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method.name,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              selected ? radioCheckIcon : radioOutIcon,
              color: selected ? cs.primary : cs.outline,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
