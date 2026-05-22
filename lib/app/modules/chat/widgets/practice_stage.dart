import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/session_entity.dart';

class PracticeStage extends StatelessWidget {
  const PracticeStage({
    required this.aiInitials,
    required this.aiName,
    required this.aiRole,
    required this.stateLabel,
    required this.state,
    required this.voiceActive,
    this.compact = false,
    super.key,
  });

  final String aiInitials;
  final String aiName;
  final String aiRole;
  final String stateLabel;
  final PracticeRealtimeState state;
  final bool voiceActive;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bool aiActive =
        state == PracticeRealtimeState.aiThinking ||
        state == PracticeRealtimeState.aiSpeaking;
    final bool userActive = state == PracticeRealtimeState.userSpeaking;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.md,
        AppDimensions.md,
        AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary900.withValues(alpha: 0.08),
            blurRadius: voiceActive ? 30 : 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          _ConversationStatusPill(
            label: stateLabel,
            voiceActive: voiceActive,
            state: state,
          ),
          SizedBox(height: compact ? AppDimensions.sm : AppDimensions.md),
          _AiVoiceOrb(
            initials: aiInitials,
            active: aiActive,
            speaking: state == PracticeRealtimeState.aiSpeaking,
            size: compact ? 84 : 132,
          ),
          SizedBox(height: compact ? AppDimensions.sm : AppDimensions.md),
          Text(
            aiName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2,
          ),
          if (!compact) ...<Widget>[
            const SizedBox(height: AppDimensions.xs),
            Text(
              aiRole,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: compact ? AppDimensions.sm : AppDimensions.md),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: userActive ? AppColors.secondary50 : AppColors.primary50,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              border: Border.all(
                color: userActive
                    ? AppColors.secondary300
                    : AppColors.primary200,
              ),
            ),
            child: Text(
              userActive
                  ? 'Mic đang nghe giọng của bạn'
                  : 'AI nói thì mic tự khóa, AI xong sẽ mở lại',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelMedium.copyWith(
                color: userActive
                    ? AppColors.secondary700
                    : AppColors.primary800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationStatusPill extends StatelessWidget {
  const _ConversationStatusPill({
    required this.label,
    required this.voiceActive,
    required this.state,
  });

  final String label;
  final bool voiceActive;
  final PracticeRealtimeState state;

  @override
  Widget build(BuildContext context) {
    final bool isError = state == PracticeRealtimeState.error;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: isError
            ? AppColors.errorBg
            : voiceActive
            ? AppColors.secondary50
            : AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: isError
              ? AppColors.error.withValues(alpha: 0.26)
              : voiceActive
              ? AppColors.secondary300
              : AppColors.primary200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isError
                  ? AppColors.error
                  : voiceActive
                  ? AppColors.secondary500
                  : AppColors.primary500,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isError ? AppColors.error : AppColors.primary900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AiVoiceOrb extends StatefulWidget {
  const _AiVoiceOrb({
    required this.initials,
    required this.active,
    required this.speaking,
    required this.size,
  });

  final String initials;
  final bool active;
  final bool speaking;
  final double size;

  @override
  State<_AiVoiceOrb> createState() => _AiVoiceOrbState();
}

class _AiVoiceOrbState extends State<_AiVoiceOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    );
    if (widget.active) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _AiVoiceOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
      return;
    }

    if (!widget.active && _controller.isAnimating) {
      _controller.stop();
      _controller.animateTo(0, duration: const Duration(milliseconds: 260));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double outerWaveSize = widget.size * 0.72;
    final double rotatingSize = widget.size * 0.74;
    final double innerSize = widget.size * 0.59;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double wave = widget.active ? _controller.value : 0.0;
          final double breath = widget.speaking ? wave : wave * 0.55;
          final double rotation = wave * math.pi * 2;

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              for (int index = 0; index < 3; index++)
                Transform.scale(
                  scale: 0.88 + (index * 0.18) + (breath * 0.16),
                  child: Container(
                    width: outerWaveSize,
                    height: outerWaveSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary500.withValues(
                          alpha: widget.active ? 0.20 - index * 0.04 : 0.08,
                        ),
                      ),
                    ),
                  ),
                ),
              Transform.rotate(
                angle: rotation * 0.16,
                child: Container(
                  width: rotatingSize,
                  height: rotatingSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: <Color>[
                        AppColors.primary800.withValues(alpha: 0.95),
                        AppColors.primary500,
                        AppColors.secondary500.withValues(alpha: 0.92),
                        AppColors.primary800.withValues(alpha: 0.95),
                      ],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.primary800.withValues(
                          alpha: widget.active ? 0.26 : 0.14,
                        ),
                        blurRadius: widget.active ? 34 : 18,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(-0.3, -0.4),
                    colors: <Color>[
                      Colors.white.withValues(alpha: 0.82),
                      AppColors.primary50.withValues(alpha: 0.42),
                      AppColors.primary800.withValues(alpha: 0.24),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.72),
                    width: 1.4,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.initials,
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        color: AppColors.primary900.withValues(alpha: 0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
