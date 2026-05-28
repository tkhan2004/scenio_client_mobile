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

class MessageEntity {
  const MessageEntity({
    required this.id,
    required this.sessionId,
    required this.author,
    required this.text,
    required this.createdAt,
    this.isHint = false,
  });

  final String id;
  final String sessionId;
  final MessageAuthor author;
  final String text;
  final DateTime createdAt;
  final bool isHint;
}
