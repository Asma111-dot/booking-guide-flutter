import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../helpers/general_helper.dart';
import '../models/discount.dart';
import '../providers/discount/discount_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/sizes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/facility_shimmer_card.dart';
import '../widgets/view_widget.dart';

class DiscountPage extends ConsumerStatefulWidget {
  const DiscountPage({super.key});

  @override
  ConsumerState<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends ConsumerState<DiscountPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(discountsProvider.notifier).fetch());
  }

  @override
  Widget build(BuildContext context) {
    final discountState = ref.watch(discountsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        appTitle: trans().discounts_and_offers,
        icon: arrowBackIcon,
      ),
      body: ViewWidget<List<Discount>>(
        meta: discountState.meta,
        data: discountState.data,
        onLoaded: (data) {
          return ListView.separated(
            padding: EdgeInsets.all(Insets.l20),
            itemCount: data.length,
            separatorBuilder: (_, __) => SizedBox(height: S.h(12)),
            itemBuilder: (context, index) {
              final discount = data[index];

              return InkWell(
                onTap: () {
                  final facility = discount.facility;
                  if (facility == null || facility.firstRoomId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(trans().no_rooms_available)),
                    );
                    return;
                  }

                  Navigator.pushNamed(
                    context,
                    Routes.roomDetails,
                    arguments: facility,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: Corners.md15,
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: S.r(5),
                        offset: Offset(0, S.h(2)),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(Insets.s12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: Corners.sm8,
                        child: CachedNetworkImage(
                          imageUrl: discount.facility?.logo ?? appIcon,
                          width: S.w(60),
                          height: S.h(60),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            appIcon,
                            width: S.w(60),
                            height: S.h(60),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            appIcon,
                            width: S.w(60),
                            height: S.h(60),
                          ),
                        ),
                      ),
                      Gaps.h12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              discount.name ?? '',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: TFont.m14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Gaps.h4,
                            Text(
                              '${trans().discount_value}: ${discount.value ?? '-'}',
                              style: TextStyle(
                                color: colorScheme.secondary,
                                fontSize: TFont.s12,
                              ),
                            ),
                            Gaps.h4,
                            Text(
                              ' ${discount.facility?.name ?? '-'}',
                              style: TextStyle(
                                color: colorScheme.secondary,
                                fontSize: TFont.xxs10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gaps.w8,
                      // const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          );
        },
        onLoading: () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 6,
          itemBuilder: (context, index) => const FacilityShimmerCard(),
        ),
        onEmpty: () => const Center(child: Text('لا يوجد خصومات متاحة حالياً')),
        showError: true,
        showEmpty: true,
      ),
    );
  }
}
