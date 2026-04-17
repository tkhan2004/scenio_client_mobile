import 'package:flutter/material.dart';

class ProfileOverviewStat {
  const ProfileOverviewStat({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color tint;
}

class ProfileWeeklyXpPoint {
  const ProfileWeeklyXpPoint({required this.dayLabel, required this.xp});

  final String dayLabel;
  final int xp;
}

class ProfileSkillScore {
  const ProfileSkillScore({
    required this.label,
    required this.score,
    required this.color,
  });

  final String label;
  final int score;
  final Color color;
}

class ProfileBadgeData {
  const ProfileBadgeData({
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.isEarned,
  });

  final String title;
  final String description;
  final IconData icon;
  final int xpReward;
  final bool isEarned;
}

class ProfileHistoryItem {
  const ProfileHistoryItem({
    required this.title,
    required this.meta,
    required this.dateLabel,
    required this.xpEarned,
    required this.averageScore,
    required this.icon,
  });

  final String title;
  final String meta;
  final String dateLabel;
  final int xpEarned;
  final int averageScore;
  final IconData icon;
}

class ProfileActionItem {
  const ProfileActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isDestructive = false,
    this.id,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDestructive;
  final String? id;
}
