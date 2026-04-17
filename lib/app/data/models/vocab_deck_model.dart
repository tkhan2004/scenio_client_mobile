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
}
