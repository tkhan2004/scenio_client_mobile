enum MessageAuthor { ai, user, system }

extension MessageAuthorX on MessageAuthor {
  String get label {
    switch (this) {
      case MessageAuthor.ai:
        return 'AI';
      case MessageAuthor.user:
        return 'You';
      case MessageAuthor.system:
        return 'System';
    }
  }
}

class MessageFeedbackIssueEntity {
  const MessageFeedbackIssueEntity({
    required this.type,
    required this.subtype,
    required this.originalPhrase,
    required this.suggestion,
    required this.explanation,
  });

  final String type;
  final String? subtype;
  final String? originalPhrase;
  final String? suggestion;
  final String? explanation;
}

class MessageEntity {
  const MessageEntity({
    required this.id,
    required this.sessionId,
    required this.author,
    required this.text,
    required this.createdAt,
    this.isHint = false,
    this.hasError,
    this.errorType,
    this.originalPhrase,
    this.suggestion,
    this.explanation,
    this.isGood,
    this.feedbackIssues = const <MessageFeedbackIssueEntity>[],
  });

  final String id;
  final String sessionId;
  final MessageAuthor author;
  final String text;
  final DateTime createdAt;
  final bool isHint;
  final bool? hasError;
  final String? errorType;
  final String? originalPhrase;
  final String? suggestion;
  final String? explanation;
  final bool? isGood;
  final List<MessageFeedbackIssueEntity> feedbackIssues;
}
