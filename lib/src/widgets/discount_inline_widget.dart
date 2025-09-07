import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../models/discount.dart';
import '../pages/discount_page.dart';
import '../providers/discount/discount_provider.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import '../widgets/view_widget.dart';

class DiscountInlineWidget extends ConsumerStatefulWidget {
  const DiscountInlineWidget({super.key});

  @override
  ConsumerState<DiscountInlineWidget> createState() =>
      _DiscountInlineWidgetState();
}

class _DiscountInlineWidgetState extends ConsumerState<DiscountInlineWidget> {
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(discountsProvider.notifier).fetch());

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;

      final nextPage = (_pageController.page ?? 0).round() + 1;
      final itemCount = ref.read(discountsProvider).data?.length ?? 0;
      if (itemCount == 0) return;

      _pageController.animateToPage(
        nextPage % itemCount,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discountState = ref.watch(discountsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return ViewWidget<List<Discount>>(
      meta: discountState.meta,
      data: discountState.data,
      onLoaded: (data) {
        if (data.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: S.h(120),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final discount = data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DiscountPage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: S.w(26), vertical: S.h(10)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(0.2),
                              colorScheme.tertiary.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: Corners.md15,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: S.r(6),
                              offset: Offset(0, S.h(3)),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(S.h(12)),
                        child: Row(
                          children: [
                            Container(
                              width: S.w(60),
                              height: S.w(60),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.15),
                                borderRadius: Corners.sm8,
                              ),
                              child: Icon(
                                localOfferIcon,
                                size: S.r(30),
                                color: colorScheme.tertiary.withOpacity(0.5),
                              ),
                            ),
                            Gaps.w12,
                            Expanded(
                              child: Text(
                                discount.name ?? '',
                                style: TextStyle(
                                  fontSize: TFont.l16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(data.length, (index) {
                    final difference = (_currentPage - index).abs();
                    final isActive = difference < 0.5;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(vertical: S.h(4)),
                      width: isActive ? S.r(14) : S.r(10),
                      height: isActive ? S.r(14) : S.r(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? colorScheme.primary.withOpacity(0.6)
                            : colorScheme.tertiary.withOpacity(0.2),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
      onLoading: () => Padding(
        padding: EdgeInsets.symmetric(horizontal: S.w(26), vertical: S.h(10)),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            height: S.h(100),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: Corners.md15,
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black12 : Colors.grey.withOpacity(0.1),
                  blurRadius: S.r(6),
                  offset: Offset(0, S.h(2)),
                ),
              ],
            ),
          ),
        ),
      ),
      onEmpty: () => SizedBox(height: S.h(150)),
      showError: false,
      showEmpty: false,
    );
  }
}
