import 'package:booking_guide/src/utils/sizes.dart';
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
          borderRadius: Corners.sm8,
          border: Border.all(
            color: selected ? cs.primary : cs.outline,
            width: 1,
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: S.w(16),
          vertical: S.h(8),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: S.w(16),
          vertical: S.h(12),
        ),
        child: Row(
          children: [
            ClipOval(
              child: Image.asset(
                method.image,
                width: S.w(40),
                height: S.h(40),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(NotImageIcon, color: cs.error, size: Sizes.iconM20),
              ),
            ),
            Gaps.w16,
            Expanded(
              child: Text(
                method.name,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(selected ? radioCheckIcon : radioOutIcon,
                color: selected ? cs.primary : cs.outline, size: Sizes.iconL24),
          ],
        ),
      ),
    );
  }
}
