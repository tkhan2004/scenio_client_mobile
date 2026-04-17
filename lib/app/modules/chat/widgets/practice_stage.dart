import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/session_entity.dart';

class PracticeStage extends StatelessWidget {
  const PracticeStage({
    required this.userInitials,
    required this.aiInitials,
    required this.aiName,
    required this.aiRole,
    required this.stateLabel,
    required this.state,
    super.key,
  });

  final String userInitials;
  final String aiInitials;
  final String aiName;
  final String aiRole;
  final String stateLabel;
  final PracticeRealtimeState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _ParticipantCard(
                  label: 'You',
                  role:
                      state == PracticeRealtimeState.userTyping ||
                          state == PracticeRealtimeState.userListening
                      ? stateLabel
                      : 'Ready',
                  initials: userInitials,
                  accent: AppColors.primary700,
                  isHighlighted:
                      state == PracticeRealtimeState.userTyping ||
                      state == PracticeRealtimeState.userListening,
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: _AiPresenceCard(
                  initials: aiInitials,
                  name: aiName,
                  role: aiRole,
                  stateLabel: stateLabel,
                  state: state,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  const _ParticipantCard({
    required this.label,
    required this.role,
    required this.initials,
    required this.accent,
    required this.isHighlighted,
  });

  final String label;
  final String role;
  final String initials;
  final Color accent;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: accent.withValues(alpha: isHighlighted ? 0.34 : 0.18),
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 72,
            child: Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      AppColors.primary50,
                      accent.withValues(alpha: 0.22),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: AppTextStyles.h2.copyWith(color: accent),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(label, style: AppTextStyles.labelLarge),
          const SizedBox(height: 2),
          Text(
            role,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiPresenceCard extends StatefulWidget {
  const _AiPresenceCard({
    required this.initials,
    required this.name,
    required this.role,
    required this.stateLabel,
    required this.state,
  });

  final String initials;
  final String name;
  final String role;
  final String stateLabel;
  final PracticeRealtimeState state;

  @override
  State<_AiPresenceCard> createState() => _AiPresenceCardState();
}

class _AiPresenceCardState extends State<_AiPresenceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSpeaking = widget.state == PracticeRealtimeState.aiSpeaking;
    final bool isThinking = widget.state == PracticeRealtimeState.aiThinking;
    final double orbitScale = isSpeaking
        ? 1.0
        : isThinking
        ? 0.62
        : 0.24;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Colors.white, AppColors.primary50],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 72,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                final double wave = 0.94 + (_controller.value * 0.14);
                final double rotation = _controller.value * math.pi * 2;

                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Transform.scale(
                      scale: wave * (0.9 + orbitScale * 0.22),
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: <Color>[
                              AppColors.primary300.withValues(alpha: 0.32),
                              AppColors.primary500.withValues(alpha: 0.06),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: rotation * 0.28,
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary500.withValues(
                              alpha: 0.24 + orbitScale * 0.24,
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            AppColors.primary800,
                            AppColors.primary700,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.primary800.withValues(
                              alpha: 0.16 + orbitScale * 0.18,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.initials,
                        style: AppTextStyles.h2.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(widget.name, style: AppTextStyles.labelLarge),
          const SizedBox(height: 2),
          Text(
            '${widget.stateLabel} • AI',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
