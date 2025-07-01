import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../helpers/general_helper.dart';
import '../models/discount.dart';
import '../providers/discount/discount_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
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
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: discount.facility?.logo ?? appIcon,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Image.asset(appIcon, width: 60, height: 60),
                          errorWidget: (context, url, error) =>
                              Image.asset(appIcon, width: 60, height: 60),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              discount.name ?? '',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${trans().discount_value}: ${discount.value ?? '-'}',
                              style: TextStyle(
                                color: colorScheme.secondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ' ${discount.facility?.name ?? '-'}',
                              style: TextStyle(
                                color: colorScheme.secondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
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
          itemCount: 6, // عدد البطاقات الوهمية أثناء التحميل
          itemBuilder: (context, index) => const FacilityShimmerCard(),
        ),
        onEmpty: () => const Center(child: Text('لا يوجد خصومات متاحة حالياً')),
        showError: true,
        showEmpty: true,
      ),
    );
  }
}
