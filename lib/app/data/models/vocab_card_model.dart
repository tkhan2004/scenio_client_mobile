class VocabCardModel {
  const VocabCardModel({
    required this.id,
    required this.deckId,
    required this.word,
    required this.phonetic,
    required this.translation,
    required this.partOfSpeech,
    required this.sampleSentence,
    required this.hintSentence,
    required this.isMastered,
  });

  final String id;
  final String deckId;
  final String word;
  final String phonetic;
  final String translation;
  final String partOfSpeech;
  final String sampleSentence;
  final String hintSentence;
  final bool isMastered;

  VocabCardModel copyWith({
    String? id,
    String? deckId,
    String? word,
    String? phonetic,
    String? translation,
    String? partOfSpeech,
    String? sampleSentence,
    String? hintSentence,
    bool? isMastered,
  }) {
    return VocabCardModel(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      word: word ?? this.word,
      phonetic: phonetic ?? this.phonetic,
      translation: translation ?? this.translation,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      sampleSentence: sampleSentence ?? this.sampleSentence,
      hintSentence: hintSentence ?? this.hintSentence,
      isMastered: isMastered ?? this.isMastered,
    );
  }

  factory VocabCardModel.fromJson(Map<String, dynamic> json) {
    return VocabCardModel(
      id: json['id'] as String,
      deckId: json['deckId'] as String,
      word: json['word'] as String,
      phonetic: json['phonetic'] as String? ?? '',
      translation: json['translation'] as String,
      partOfSpeech: json['partOfSpeech'] as String,
      sampleSentence: json['sampleSentence'] as String,
      hintSentence: json['hintSentence'] as String? ?? '',
      isMastered: json['isMastered'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'deckId': deckId,
      'word': word,
      'phonetic': phonetic,
      'translation': translation,
      'partOfSpeech': partOfSpeech,
      'sampleSentence': sampleSentence,
      'hintSentence': hintSentence,
      'isMastered': isMastered,
    };
  }

  factory VocabCardModel.fromApiMap(
    Map<String, dynamic> json, {
    required String deckId,
  }) {
    final String definition = json['definition'] as String? ?? '';
    final String example =
        json['sampleSentence'] as String? ??
        json['example'] as String? ??
        definition;
    final String hint =
        json['example'] as String? ??
        json['sampleSentence'] as String? ??
        definition;

    return VocabCardModel(
      id: json['vocabularyId'] as String? ?? json['id'] as String? ?? '',
      deckId: deckId,
      word: json['word'] as String? ?? '',
      phonetic: json['phonetic'] as String? ?? '',
      translation: definition.isNotEmpty
          ? definition
          : (json['word'] as String? ?? ''),
      partOfSpeech: json['partOfSpeech'] as String? ?? '',
      sampleSentence: example,
      hintSentence: hint,
      isMastered: json['isMastered'] as bool? ?? false,
    );
  }
}
