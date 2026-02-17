import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/assets.dart';
import '../helpers/general_helper.dart';
import '../utils/sizes.dart';

class CustomHeaderDetailsWidget extends StatelessWidget {
  final String? logo;
  final String? name;
  final String? address;

  const CustomHeaderDetailsWidget({
    super.key,
    required this.logo,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (logo != null) ...[
          Container(
            height: S.h(100),
            width: S.w(100),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.1),
                  spreadRadius: S.r(2),
                  blurRadius: S.r(3),
                  offset: Offset(0, S.h(3)),
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: logo!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox.shrink(),
                errorWidget: (context, url, error) => Image.asset(
                  appIcon,
                  fit: BoxFit.cover,
                ),
                fadeInDuration: const Duration(milliseconds: 200),
              ),
            ),
          ),
          Gaps.w8,
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.h12,
              Text(
                name ?? trans().not_available,
                style: TextStyle(
                  fontSize: TFont.xl18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Gaps.h20,
              Row(
                children: [
                  Icon(
                    mapIcon,
                    color: colorScheme.secondary,
                    size: Sizes.iconS16,
                  ),
                  Gaps.w4,
                  Expanded(
                    child: Text(
                      address ?? trans().not_available,
                      style: TextStyle(
                        fontSize: TFont.m14,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
