import '../../domain/repositories/vocab_repository.dart';
import '../models/vocab_card_model.dart';
import '../models/vocab_deck_model.dart';
import '../providers/vocab_provider.dart';

class VocabRepositoryImpl implements VocabRepository {
  VocabRepositoryImpl({required VocabProvider provider}) : _provider = provider;

  final VocabProvider _provider;

  @override
  Future<List<VocabDeckModel>> fetchDecks() async {
    final Map<String, dynamic> map = await _provider.fetchDecks();
    final List<dynamic> rawDecks =
        map['decks'] as List<dynamic>? ?? <dynamic>[];

    return rawDecks
        .whereType<Map<String, dynamic>>()
        .map(VocabDeckModel.fromApiMap)
        .toList();
  }

  @override
  Future<List<VocabCardModel>> fetchDeckCards(String deckId) async {
    final Map<String, dynamic> map = await _provider.fetchDeckCards(deckId);
    final List<dynamic> rawCards =
        map['words'] as List<dynamic>? ?? <dynamic>[];

    return rawCards
        .whereType<Map<String, dynamic>>()
        .map(
          (Map<String, dynamic> item) =>
              VocabCardModel.fromApiMap(item, deckId: deckId),
        )
        .toList();
  }

  @override
  Future<void> saveManualVocabulary({
    required String word,
    required String definition,
    required String sourceSessionId,
    required String sampleSentence,
    String? sourceMessageId,
  }) async {
    await _provider.saveManualVocabulary(
      word: word,
      definition: definition,
      sourceSessionId: sourceSessionId,
      sampleSentence: sampleSentence,
      sourceMessageId: sourceMessageId,
    );
  }

  @override
  Future<void> markWordAsDone(String wordId) async {
    await _provider.markWordAsDone(wordId);
  }
}
