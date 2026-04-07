import 'dart:math' as math;
import 'package:flutter/material.dart';

class ScenioMark extends StatelessWidget {
  const ScenioMark({
    super.key,
    this.size = 72,
    this.color = const Color(0xFFF6CF59),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double pillWidth = size * 0.28;
    final double pillHeight = size * 0.14;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          _MarkPill(
            left: size * 0.08,
            top: size * 0.24,
            width: pillWidth,
            height: pillHeight,
            color: color,
          ),
          _MarkPill(
            left: size * 0.40,
            top: size * 0.05,
            width: pillWidth,
            height: pillHeight,
            color: color,
          ),
          _MarkPill(
            left: size * 0.08,
            top: size * 0.52,
            width: pillWidth,
            height: pillHeight,
            color: color,
          ),
          _MarkPill(
            left: size * 0.40,
            top: size * 0.33,
            width: pillWidth,
            height: pillHeight,
            color: color,
          ),
          _MarkPill(
            left: size * 0.08,
            top: size * 0.80,
            width: pillWidth,
            height: pillHeight,
            color: color,
          ),
          _MarkPill(
            left: size * 0.40,
            top: size * 0.61,
            width: pillWidth,
            height: pillHeight,
            color: color,
          ),
        ],
      ),
    );
  }
}

class _MarkPill extends StatelessWidget {
  const _MarkPill({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.color,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
        angle: -math.pi / 4,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(height),
          ),
        ),
      ),
    );
  }
}
