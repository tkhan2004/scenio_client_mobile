import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../home_viewmodel.dart';

class HomePillNavBar extends StatelessWidget {
  const HomePillNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<HomeTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  static const double navBarWidth = 382;
  static const double navBarHeight = 56;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double resolvedWidth = math.min(
      navBarWidth,
      screenWidth - (AppDimensions.md * 2),
    );

    return SizedBox(
      width: resolvedWidth,
      height: navBarHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: AppColors.primary200.withValues(alpha: 0.85),
            width: 0.8,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary900.withValues(alpha: 0.08),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double slotWidth = constraints.maxWidth / items.length;
            final double indicatorWidth = math.min(64, slotWidth - 10);

            return Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  left:
                      currentIndex * slotWidth +
                      (slotWidth - indicatorWidth) / 2,
                  top: 5,
                  bottom: 5,
                  child: Container(
                    width: indicatorWidth,
                    decoration: BoxDecoration(
                      color: AppColors.primary200.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.9),
                        width: 0.9,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: List<Widget>.generate(items.length, (int index) {
                    final bool isSelected = index == currentIndex;
                    final HomeTabItem item = items[index];

                    return Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusFull,
                          ),
                          onTap: () => onSelected(index),
                          child: Center(
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              size: isSelected
                                  ? AppDimensions.iconLg
                                  : AppDimensions.iconMd,
                              color: isSelected
                                  ? AppColors.primary900
                                  : AppColors.neutral300,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
