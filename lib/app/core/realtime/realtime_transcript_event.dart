import '../../domain/entities/message_entity.dart';

class RealtimeTranscriptEvent {
  const RealtimeTranscriptEvent({
    required this.author,
    required this.content,
    required this.isFinal,
    this.providerEventId,
    this.audioStartMs,
    this.audioEndMs,
  });

  final MessageAuthor author;
  final String content;
  final bool isFinal;
  final String? providerEventId;
  final int? audioStartMs;
  final int? audioEndMs;

  String get backendSource =>
      author == MessageAuthor.user ? 'USER_AUDIO' : 'AI_AUDIO';
}
