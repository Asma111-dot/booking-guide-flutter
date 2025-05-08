import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../helpers/general_helper.dart';

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
    return Row(
      children: [
        if (logo != null) ...[
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: CustomTheme.color2.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: logo!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  logoCoverImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "  ${name ?? trans().not_available}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.primaryColor,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: CustomTheme.color2,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    " ${address ?? trans().not_available}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: CustomTheme.color3,
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
