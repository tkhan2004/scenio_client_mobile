import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class VocabProvider {
  VocabProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> fetchDecks() {
    return _apiClient.get(ApiEndpoints.vocabularyDecks);
  }

  Future<Map<String, dynamic>> fetchDeckCards(String deckId) {
    return _apiClient.get(ApiEndpoints.vocabularyDeckDetail(deckId));
  }

  Future<Map<String, dynamic>> saveManualVocabulary({
    required String word,
    String? definition,
    required String sourceSessionId,
    required String sampleSentence,
    String? sourceMessageId,
  }) {
    return _apiClient.post(
      ApiEndpoints.vocabulary,
      data: <String, dynamic>{
        'word': word,
        if (definition != null && definition.trim().isNotEmpty)
          'definition': definition.trim(),
        'sourceSessionId': sourceSessionId,
        'sampleSentence': sampleSentence,
        if (sourceMessageId != null && sourceMessageId.isNotEmpty)
          'sourceMessageId': sourceMessageId,
      },
    );
  }

  Future<Map<String, dynamic>> markWordAsDone(String wordId) {
    return _apiClient.post(
      ApiEndpoints.vocabularyReview(wordId),
      data: const <String, dynamic>{'isDone': true, 'recallQuality': 5},
    );
  }
}
