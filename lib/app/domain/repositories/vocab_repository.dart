import '../../data/models/vocab_card_model.dart';
import '../../data/models/vocab_deck_model.dart';

abstract class VocabRepository {
  Future<List<VocabDeckModel>> fetchDecks();

  Future<List<VocabCardModel>> fetchDeckCards(String deckId);

  Future<void> markWordAsDone(String wordId);
}
