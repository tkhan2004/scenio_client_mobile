import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class ScenioSkeletonBox extends StatefulWidget {
  const ScenioSkeletonBox({
    this.width,
    required this.height,
    this.radius = AppDimensions.radiusMd,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  final double? width;
  final double height;
  final double radius;
  final EdgeInsetsGeometry margin;

  @override
  State<ScenioSkeletonBox> createState() => _ScenioSkeletonBoxState();
}

class _ScenioSkeletonBoxState extends State<ScenioSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double shimmer = _controller.value;

        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1.8 + shimmer * 2.6, -0.7),
              end: Alignment(-0.2 + shimmer * 2.6, 0.7),
              colors: <Color>[
                AppColors.primary50.withValues(alpha: 0.62),
                Colors.white.withValues(alpha: 0.96),
                AppColors.primary50.withValues(alpha: 0.72),
              ],
              stops: const <double>[0.1, 0.48, 0.9],
            ),
            border: Border.all(
              color: AppColors.primary200.withValues(alpha: 0.42),
            ),
          ),
        );
      },
    );
  }
}

class ScenioSkeletonLine extends StatelessWidget {
  const ScenioSkeletonLine({
    this.width,
    this.widthFactor,
    this.height = 12,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  final double? width;
  final double? widthFactor;
  final double height;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final Widget line = ScenioSkeletonBox(
      width: width,
      height: height,
      radius: AppDimensions.radiusFull,
      margin: margin,
    );

    if (widthFactor == null) return line;

    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: line,
    );
  }
}

class ScenioSkeletonCard extends StatelessWidget {
  const ScenioSkeletonCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.lg),
    this.margin = EdgeInsets.zero,
    this.radius = AppDimensions.radiusLg,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.7)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
