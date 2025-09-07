import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/facility.dart' as f;
import '../utils/assets.dart';
import '../utils/theme.dart';

class FacilitySearchDelegate extends SearchDelegate<f.Facility?> {
  final List<f.Facility> all;

  FacilitySearchDelegate(this.all)
      : super(
          searchFieldLabel: trans().searchFieldLabel,
          searchFieldStyle: const TextStyle(
            fontSize: 12,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: cs.background,
        elevation: 0,
        foregroundColor: cs.onBackground,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        fillColor: cs.surfaceVariant.withOpacity(.5),
        hintStyle: TextStyle(color: cs.onSurface.withOpacity(.6), fontSize: 12),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: cs.primary,
        selectionColor: cs.primary.withOpacity(.2),
        selectionHandleColor: cs.primary,
      ),
      textTheme: theme.textTheme.apply(
        bodyColor: cs.onBackground,
        displayColor: cs.onBackground,
      ),
      iconTheme: theme.iconTheme.copyWith(color: cs.onBackground),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'مسح',
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: CustomTheme.primaryGradient,
            ),
            child: const Icon(closeIcon, size: 18, color: Colors.white),
          ),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        tooltip: 'رجوع',
        icon: Icon(
          goBackIcon,
          color: CustomTheme.color2,
        ),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final q = query.trim().toLowerCase();

    final results = q.isEmpty
        ? all
        : all.where((e) => (e.name).toLowerCase().contains(q)).toList();

    if (results.isEmpty) {
      return _EmptyState(
        title: trans().no_matching_facilities_title,
        subtitle: trans().no_matching_facilities_subtitle,
        svgAsset: mapIconSvg,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: results.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: cs.outlineVariant.withOpacity(.4),
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (context, i) {
        final item = results[i];

        return InkWell(
          onTap: () => close(context, item),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                // أيقونة بنمط الخريطة مع خلفية ناعمة
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: CustomTheme.color1.withOpacity(.08),
                  ),
                  child: Icon(
                    mapIcon,
                    size: 22,
                    color: CustomTheme.color3,
                  ),
                ),
                const SizedBox(width: 12),
                // الاسم + العنوان
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: CustomTheme.color2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if ((item.address?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.address!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CustomTheme.primaryColor,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgAsset;

  const _EmptyState({
    required this.title,
    required this.subtitle,
    required this.svgAsset,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(svgAsset, width: 140, height: 140),
            const SizedBox(height: 16),
            Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: cs.onBackground,
                )),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: cs.onSurface.withOpacity(.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
