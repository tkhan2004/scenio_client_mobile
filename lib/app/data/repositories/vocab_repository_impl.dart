import '../../domain/repositories/vocab_repository.dart';
import '../models/vocab_card_model.dart';
import '../models/vocab_deck_model.dart';
import '../providers/vocab_provider.dart';

class VocabRepositoryImpl implements VocabRepository {
  VocabRepositoryImpl({required VocabProvider provider}) : _provider = provider;

  final VocabProvider _provider;

  @override
  Future<List<VocabDeckModel>> fetchDecks() {
    return _provider.fetchDecks();
  }

  @override
  Future<List<VocabCardModel>> fetchDeckCards(String deckId) {
    return _provider.fetchDeckCards(deckId);
  }

  @override
  Future<void> markWordAsDone(String wordId) {
    return _provider.markWordAsDone(wordId);
  }
}
