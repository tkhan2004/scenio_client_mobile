import 'dart:typed_data';

import '../../data/models/vocab_card_model.dart';
import '../../data/models/vocab_deck_model.dart';

abstract class VocabRepository {
  Future<List<VocabDeckModel>> fetchDecks();

  Future<List<VocabCardModel>> fetchDeckCards(String deckId);

  Future<Uint8List> fetchPronunciationAudio(String text);

  Future<void> saveManualVocabulary({
    required String word,
    String? definition,
    required String sourceSessionId,
    required String sampleSentence,
    String? sourceMessageId,
  });

  Future<void> markWordAsDone(String wordId);
}
