import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/message_entity.dart';

typedef VocabularySaveCallback =
    Future<void> Function({
      required String word,
      required MessageEntity message,
    });

class PracticeTranscriptPanel extends StatelessWidget {
  const PracticeTranscriptPanel({
    required this.messages,
    required this.expanded,
    required this.onToggle,
    this.onSaveVocabulary,
    super.key,
  });

  final List<MessageEntity> messages;
  final bool expanded;
  final VoidCallback onToggle;
  final VocabularySaveCallback? onSaveVocabulary;

  @override
  Widget build(BuildContext context) {
    final List<MessageEntity> visibleMessages = expanded
        ? messages
        : messages.reversed.take(4).toList().reversed.toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(AppStrings.practiceTranscriptTitle, style: AppTextStyles.h3),
              const Spacer(),
              TextButton(
                onPressed: onToggle,
                child: Text(
                  expanded
                      ? AppStrings.practiceTranscriptHide
                      : AppStrings.practiceTranscriptShow,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          ...visibleMessages.map(
            (MessageEntity message) => Padding(
              padding: EdgeInsets.only(
                bottom: message == visibleMessages.last ? 0 : AppDimensions.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 52,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message.isHint
                              ? AppStrings.practiceControlHint
                              : message.author.label,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: message.isHint
                                ? AppColors.warning
                                : message.author == MessageAuthor.ai
                                ? AppColors.primary700
                                : AppColors.secondary500,
                          ),
                        ),
                        if (message.isHint) ...<Widget>[
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warningBg,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                              border: Border.all(
                                color: AppColors.warning.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              'AI',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: _InteractiveTranscriptText(
                      message: message,
                      onSaveVocabulary: onSaveVocabulary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveTranscriptText extends StatelessWidget {
  const _InteractiveTranscriptText({
    required this.message,
    required this.onSaveVocabulary,
  });

  static const Set<String> _ignoredWords = <String>{
    'the',
    'and',
    'you',
    'your',
    'are',
    'for',
    'with',
    'this',
    'that',
    'can',
    'how',
    'what',
    'have',
    'has',
    'was',
    'were',
    'will',
    'hello',
    'today',
  };

  final MessageEntity message;
  final VocabularySaveCallback? onSaveVocabulary;

  @override
  Widget build(BuildContext context) {
    if (message.isHint) {
      return Text(
        message.text,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.warning,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    final TextStyle baseStyle = AppTextStyles.bodySmall.copyWith(
      color: AppColors.textSecondary,
    );
    final List<String> tokens = RegExp(
      r'\S+\s*',
    ).allMatches(message.text).map((RegExpMatch match) => match[0]!).toList();

    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: tokens
          .map(
            (String token) => _TranscriptToken(
              token: token,
              cleanWord: _cleanWord(token),
              baseStyle: baseStyle,
              message: message,
              onSaveVocabulary: onSaveVocabulary,
            ),
          )
          .toList(),
    );
  }

  static String _cleanWord(String token) {
    return token.replaceAll(RegExp(r"(^[^A-Za-z']+|[^A-Za-z']+$)"), '').trim();
  }

  static bool isVocabularyCandidate(String word) {
    final String normalized = word.toLowerCase();
    return normalized.length >= 3 &&
        RegExp(r"[A-Za-z]").hasMatch(normalized) &&
        !_ignoredWords.contains(normalized);
  }
}

class _TranscriptToken extends StatelessWidget {
  const _TranscriptToken({
    required this.token,
    required this.cleanWord,
    required this.baseStyle,
    required this.message,
    required this.onSaveVocabulary,
  });

  final String token;
  final String cleanWord;
  final TextStyle baseStyle;
  final MessageEntity message;
  final VocabularySaveCallback? onSaveVocabulary;

  @override
  Widget build(BuildContext context) {
    if (onSaveVocabulary == null ||
        !_InteractiveTranscriptText.isVocabularyCandidate(cleanWord)) {
      return Text(token, style: baseStyle);
    }

    return Tooltip(
      message: AppStrings.practiceVocabularyTooltip.replaceFirst(
        '{word}',
        cleanWord,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (TapDownDetails details) => _showVocabularyMenu(
          context: context,
          position: details.globalPosition,
        ),
        child: Text(
          token,
          style: baseStyle.copyWith(
            color: AppColors.primary800,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.primary300,
            decorationThickness: 1.2,
          ),
        ),
      ),
    );
  }

  Future<void> _showVocabularyMenu({
    required BuildContext context,
    required Offset position,
  }) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final String? selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 1, 1),
        Offset.zero & overlay.size,
      ),
      color: Colors.white.withValues(alpha: 0.96),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        side: BorderSide(color: AppColors.primary200.withValues(alpha: 0.9)),
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'save',
          padding: EdgeInsets.zero,
          child: _VocabularyPopupContent(
            word: cleanWord,
            contextSentence: message.text,
          ),
        ),
      ],
    );

    if (selected == 'save') {
      await onSaveVocabulary?.call(word: cleanWord, message: message);
    }
  }
}

class _VocabularyPopupContent extends StatelessWidget {
  const _VocabularyPopupContent({
    required this.word,
    required this.contextSentence,
  });

  final String word;
  final String contextSentence;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 254,
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AppStrings.practiceVocabularyPopupTitle,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary700,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            word,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            AppStrings.practiceVocabularyPopupContext,
            style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            contextSentence,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: <Widget>[
              Icon(
                Icons.bookmark_add_rounded,
                size: AppDimensions.iconSm,
                color: AppColors.primary700,
              ),
              const SizedBox(width: AppDimensions.sm),
              Text(
                AppStrings.practiceVocabularySaveAction,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
