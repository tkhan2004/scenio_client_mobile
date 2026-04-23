import 'package:flutter/material.dart';

class VocabDeckModel {
  const VocabDeckModel({
    required this.id,
    required this.title,
    required this.sceneLabel,
    required this.createdLabel,
    required this.wordsCount,
    required this.masteredCount,
    required this.dueWordsCount,
    required this.icon,
    required this.tint,
  });

  final String id;
  final String title;
  final String sceneLabel;
  final String createdLabel;
  final int wordsCount;
  final int masteredCount;
  final int dueWordsCount;
  final IconData icon;
  final Color tint;

  double get progress => wordsCount == 0 ? 0 : masteredCount / wordsCount;
  bool get isCompleted => wordsCount > 0 && masteredCount >= wordsCount;

  VocabDeckModel copyWith({
    String? id,
    String? title,
    String? sceneLabel,
    String? createdLabel,
    int? wordsCount,
    int? masteredCount,
    int? dueWordsCount,
    IconData? icon,
    Color? tint,
  }) {
    return VocabDeckModel(
      id: id ?? this.id,
      title: title ?? this.title,
      sceneLabel: sceneLabel ?? this.sceneLabel,
      createdLabel: createdLabel ?? this.createdLabel,
      wordsCount: wordsCount ?? this.wordsCount,
      masteredCount: masteredCount ?? this.masteredCount,
      dueWordsCount: dueWordsCount ?? this.dueWordsCount,
      icon: icon ?? this.icon,
      tint: tint ?? this.tint,
    );
  }

  factory VocabDeckModel.fromJson(Map<String, dynamic> json) {
    return VocabDeckModel(
      id: json['id'] as String,
      title: json['title'] as String,
      sceneLabel: json['sceneLabel'] as String,
      createdLabel: json['createdLabel'] as String,
      wordsCount: json['wordsCount'] as int,
      masteredCount: json['masteredCount'] as int,
      dueWordsCount: json['dueWordsCount'] as int,
      icon: IconData(json['iconCodePoint'] as int, fontFamily: 'MaterialIcons'),
      tint: Color(json['tintValue'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'sceneLabel': sceneLabel,
      'createdLabel': createdLabel,
      'wordsCount': wordsCount,
      'masteredCount': masteredCount,
      'dueWordsCount': dueWordsCount,
      'iconCodePoint': icon.codePoint,
      'tintValue': tint.toARGB32(),
    };
  }

  factory VocabDeckModel.fromApiMap(Map<String, dynamic> json) {
    final Map<String, dynamic> scene =
        json['scene'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final String category = scene['category'] as String? ?? '';
    final String difficulty = scene['difficulty'] as String? ?? '';
    final DateTime? anchorDate = DateTime.tryParse(
      (json['latestEncounterAt'] ??
              json['endedAt'] ??
              json['startedAt'] ??
              '') as String,
    );
    final _DeckVisualMeta meta = _DeckVisualMeta.fromCategory(category);

    return VocabDeckModel(
      id: json['sessionId'] as String? ?? '',
      title: scene['title'] as String? ?? 'Custom practice',
      sceneLabel: _buildSceneLabel(category: category, difficulty: difficulty),
      createdLabel: _buildCreatedLabel(anchorDate),
      wordsCount: (json['wordsCount'] as num?)?.toInt() ?? 0,
      masteredCount: (json['masteredCount'] as num?)?.toInt() ?? 0,
      dueWordsCount: (json['dueWordsCount'] as num?)?.toInt() ?? 0,
      icon: meta.icon,
      tint: meta.tint,
    );
  }
}

String _buildSceneLabel({
  required String category,
  required String difficulty,
}) {
  final String readableCategory = _formatCategory(category);
  final String readableDifficulty = difficulty.trim();

  if (readableCategory.isEmpty && readableDifficulty.isEmpty) {
    return 'Context deck';
  }

  if (readableDifficulty.isEmpty) {
    return readableCategory;
  }

  if (readableCategory.isEmpty) {
    return readableDifficulty;
  }

  return '$readableCategory • $readableDifficulty';
}

String _buildCreatedLabel(DateTime? date) {
  if (date == null) {
    return 'Saved after recent practice';
  }

  const List<String> months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final String month = months[date.month - 1];
  final String day = date.day.toString().padLeft(2, '0');
  return 'Saved after $month $day session';
}

String _formatCategory(String category) {
  switch (category.toUpperCase()) {
    case 'TRAVEL':
      return 'Travel';
    case 'WORK':
      return 'Work';
    case 'DAILY':
      return 'Daily life';
    case 'SOCIAL':
      return 'Social';
    default:
      return '';
  }
}

class _DeckVisualMeta {
  const _DeckVisualMeta({required this.icon, required this.tint});

  final IconData icon;
  final Color tint;

  factory _DeckVisualMeta.fromCategory(String category) {
    switch (category.toUpperCase()) {
      case 'TRAVEL':
        return const _DeckVisualMeta(
          icon: Icons.flight_takeoff_rounded,
          tint: Color(0xFF457FAF),
        );
      case 'WORK':
        return const _DeckVisualMeta(
          icon: Icons.work_outline_rounded,
          tint: Color(0xFF1D9E75),
        );
      case 'SOCIAL':
        return const _DeckVisualMeta(
          icon: Icons.people_alt_outlined,
          tint: Color(0xFF8B6BD6),
        );
      case 'DAILY':
      default:
        return const _DeckVisualMeta(
          icon: Icons.local_cafe_rounded,
          tint: Color(0xFF66A7DA),
        );
    }
  }
}
