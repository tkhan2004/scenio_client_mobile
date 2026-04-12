import 'package:flutter/material.dart';

class ScenioIconBadge extends StatelessWidget {
  const ScenioIconBadge({
    required this.icon,
    required this.tint,
    this.size = 40,
    this.iconSize,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final Color tint;
  final double size;
  final double? iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final double resolvedIconSize = iconSize ?? (size * 0.42);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            left: size * 0.08,
            top: size * 0.1,
            child: Transform.rotate(
              angle: -0.18,
              child: Container(
                width: size * 0.76,
                height: size * 0.76,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(size * 0.26),
                ),
              ),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.white, tint.withValues(alpha: 0.18)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size * 0.42),
                topRight: Radius.circular(size * 0.26),
                bottomLeft: Radius.circular(size * 0.3),
                bottomRight: Radius.circular(size * 0.42),
              ),
              border: Border.all(color: tint.withValues(alpha: 0.22)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: tint.withValues(alpha: 0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: size * 0.14,
                  right: size * 0.14,
                  child: Container(
                    width: size * 0.16,
                    height: size * 0.16,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    icon,
                    size: resolvedIconSize,
                    color: iconColor ?? tint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
