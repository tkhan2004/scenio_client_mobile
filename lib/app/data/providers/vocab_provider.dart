import 'dart:async';

import 'package:flutter/material.dart';

import '../models/vocab_card_model.dart';
import '../models/vocab_deck_model.dart';

class VocabProvider {
  final List<_DeckSeed> _deckSeeds = <_DeckSeed>[
    _DeckSeed(
      id: 'deck-cafe',
      title: 'Cafe small talk',
      sceneLabel: 'Daily life',
      createdLabel: 'Saved after Apr 08 session',
      icon: Icons.local_cafe_rounded,
      tint: const Color(0xFF66A7DA),
    ),
    _DeckSeed(
      id: 'deck-airport',
      title: 'Airport check-in',
      sceneLabel: 'Travel',
      createdLabel: 'Saved after Apr 09 session',
      icon: Icons.flight_takeoff_rounded,
      tint: const Color(0xFF457FAF),
    ),
    _DeckSeed(
      id: 'deck-interview',
      title: 'Job interview',
      sceneLabel: 'Work',
      createdLabel: 'Saved after Apr 11 session',
      icon: Icons.work_outline_rounded,
      tint: const Color(0xFF1D9E75),
    ),
    _DeckSeed(
      id: 'deck-hotel',
      title: 'Hotel front desk',
      sceneLabel: 'Service',
      createdLabel: 'Saved after Apr 13 session',
      icon: Icons.hotel_rounded,
      tint: const Color(0xFFEF9F27),
    ),
  ];

  late final Map<String, List<VocabCardModel>>
  _cardsByDeck = <String, List<VocabCardModel>>{
    'deck-cafe': <VocabCardModel>[
      const VocabCardModel(
        id: 'card-cafe-receipt',
        deckId: 'deck-cafe',
        word: 'receipt',
        phonetic: '/rɪˈsiːt/',
        translation: 'hoa don',
        partOfSpeech: 'noun',
        sampleSentence: 'Would you like the receipt in the bag or separately?',
        hintSentence: 'The barista asked whether you needed proof of payment.',
        isMastered: false,
      ),
      const VocabCardModel(
        id: 'card-cafe-for-here',
        deckId: 'deck-cafe',
        word: 'for here',
        phonetic: '/fɔːr hɪr/',
        translation: 'dung tai quan',
        partOfSpeech: 'phrase',
        sampleSentence: 'I will have an iced latte for here, please.',
        hintSentence: 'Use this phrase when you stay and drink at the cafe.',
        isMastered: true,
      ),
      const VocabCardModel(
        id: 'card-cafe-oat-milk',
        deckId: 'deck-cafe',
        word: 'oat milk',
        phonetic: '/oʊt mɪlk/',
        translation: 'sua yen mach',
        partOfSpeech: 'noun',
        sampleSentence:
            'Could you make it with oat milk instead of regular milk?',
        hintSentence:
            'A common milk alternative people ask for in modern cafes.',
        isMastered: false,
      ),
      const VocabCardModel(
        id: 'card-cafe-whipped-cream',
        deckId: 'deck-cafe',
        word: 'whipped cream',
        phonetic: '/wɪpt kriːm/',
        translation: 'kem tuoi danh bong',
        partOfSpeech: 'noun',
        sampleSentence: 'Would you like whipped cream on top of your drink?',
        hintSentence: 'A sweet topping often added to cold drinks.',
        isMastered: false,
      ),
    ],
    'deck-airport': <VocabCardModel>[
      const VocabCardModel(
        id: 'card-airport-boarding-pass',
        deckId: 'deck-airport',
        word: 'boarding pass',
        phonetic: '/ˈbɔːr.dɪŋ pæs/',
        translation: 'the len may bay',
        partOfSpeech: 'noun',
        sampleSentence: 'Here is your boarding pass for gate twelve.',
        hintSentence: 'The document you show before entering the plane.',
        isMastered: false,
      ),
      const VocabCardModel(
        id: 'card-airport-carry-on',
        deckId: 'deck-airport',
        word: 'carry-on',
        phonetic: '/ˈkær.i ɑːn/',
        translation: 'hanh ly xach tay',
        partOfSpeech: 'noun',
        sampleSentence: 'Do you have any carry-on luggage with you today?',
        hintSentence:
            'This bag stays with you instead of going under the plane.',
        isMastered: false,
      ),
      const VocabCardModel(
        id: 'card-airport-check-in-counter',
        deckId: 'deck-airport',
        word: 'check-in counter',
        phonetic: '/ˈtʃek ɪn ˈkaʊn.t̬ɚ/',
        translation: 'quay lam thu tuc',
        partOfSpeech: 'noun',
        sampleSentence:
            'The check-in counter opens two hours before departure.',
        hintSentence: 'The desk where you confirm your flight and bags.',
        isMastered: true,
      ),
      const VocabCardModel(
        id: 'card-airport-window-seat',
        deckId: 'deck-airport',
        word: 'window seat',
        phonetic: '/ˈwɪn.doʊ siːt/',
        translation: 'ghe canh cua so',
        partOfSpeech: 'noun',
        sampleSentence: 'I would prefer a window seat if one is available.',
        hintSentence: 'A seat next to the aircraft window.',
        isMastered: false,
      ),
    ],
    'deck-interview': <VocabCardModel>[
      const VocabCardModel(
        id: 'card-interview-strength',
        deckId: 'deck-interview',
        word: 'strength',
        phonetic: '/streŋθ/',
        translation: 'diem manh',
        partOfSpeech: 'noun',
        sampleSentence: 'One strength I bring is staying calm under pressure.',
        hintSentence: 'Interviewers often ask you to describe one of these.',
        isMastered: false,
      ),
      const VocabCardModel(
        id: 'card-interview-responsibility',
        deckId: 'deck-interview',
        word: 'responsibility',
        phonetic: '/rɪˌspɑːn.səˈbɪl.ə.t̬i/',
        translation: 'trach nhiem',
        partOfSpeech: 'noun',
        sampleSentence:
            'My main responsibility was coordinating the weekly report.',
        hintSentence:
            'Use this to describe the work you handled in a past role.',
        isMastered: false,
      ),
      const VocabCardModel(
        id: 'card-interview-deadline',
        deckId: 'deck-interview',
        word: 'deadline',
        phonetic: '/ˈded.laɪn/',
        translation: 'han chot',
        partOfSpeech: 'noun',
        sampleSentence:
            'I usually break big tasks down so I can meet every deadline.',
        hintSentence: 'The final time by which a task must be completed.',
        isMastered: false,
      ),
    ],
    'deck-hotel': <VocabCardModel>[
      const VocabCardModel(
        id: 'card-hotel-reservation',
        deckId: 'deck-hotel',
        word: 'reservation',
        phonetic: '/ˌrez.ɚˈveɪ.ʃən/',
        translation: 'dat phong',
        partOfSpeech: 'noun',
        sampleSentence:
            'I have a reservation under the name Nguyen for two nights.',
        hintSentence: 'The booking you already made before arrival.',
        isMastered: true,
      ),
      const VocabCardModel(
        id: 'card-hotel-late-checkout',
        deckId: 'deck-hotel',
        word: 'late checkout',
        phonetic: '/leɪt ˈtʃek.aʊt/',
        translation: 'tra phong muon',
        partOfSpeech: 'noun',
        sampleSentence: 'Is late checkout available for tomorrow morning?',
        hintSentence:
            'A polite request to leave the room after the usual time.',
        isMastered: true,
      ),
      const VocabCardModel(
        id: 'card-hotel-single-room',
        deckId: 'deck-hotel',
        word: 'single room',
        phonetic: '/ˈsɪŋ.ɡəl ruːm/',
        translation: 'phong don',
        partOfSpeech: 'noun',
        sampleSentence: 'I booked a single room with a quiet view.',
        hintSentence: 'A room designed for one guest.',
        isMastered: true,
      ),
    ],
  };

  Future<List<VocabDeckModel>> fetchDecks() async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    return _deckSeeds.map(_mapDeckFromSeed).toList();
  }

  Future<List<VocabCardModel>> fetchDeckCards(String deckId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final List<VocabCardModel>? cards = _cardsByDeck[deckId];
    if (cards == null) {
      throw StateError('Deck not found for $deckId');
    }
    return cards.map((VocabCardModel card) => card.copyWith()).toList();
  }

  Future<void> markWordAsDone(String wordId) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));

    for (final MapEntry<String, List<VocabCardModel>> entry
        in _cardsByDeck.entries) {
      final int cardIndex = entry.value.indexWhere(
        (VocabCardModel card) => card.id == wordId,
      );
      if (cardIndex == -1) {
        continue;
      }
      final VocabCardModel card = entry.value[cardIndex];
      entry.value[cardIndex] = card.copyWith(isMastered: true);
      return;
    }

    throw StateError('Vocabulary card not found for $wordId');
  }

  VocabDeckModel _mapDeckFromSeed(_DeckSeed seed) {
    final List<VocabCardModel> cards =
        _cardsByDeck[seed.id] ?? <VocabCardModel>[];
    final int masteredCount = cards
        .where((VocabCardModel card) => card.isMastered)
        .length;
    final int dueWordsCount = cards.length - masteredCount;

    return VocabDeckModel(
      id: seed.id,
      title: seed.title,
      sceneLabel: seed.sceneLabel,
      createdLabel: seed.createdLabel,
      wordsCount: cards.length,
      masteredCount: masteredCount,
      dueWordsCount: dueWordsCount,
      icon: seed.icon,
      tint: seed.tint,
    );
  }
}

class _DeckSeed {
  const _DeckSeed({
    required this.id,
    required this.title,
    required this.sceneLabel,
    required this.createdLabel,
    required this.icon,
    required this.tint,
  });

  final String id;
  final String title;
  final String sceneLabel;
  final String createdLabel;
  final IconData icon;
  final Color tint;
}
