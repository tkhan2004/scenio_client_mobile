import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_response.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../data/models/vocab_card_model.dart';
import '../../data/models/vocab_deck_model.dart';
import '../../domain/repositories/vocab_repository.dart';
import 'widgets/vocab_flashcard_stage.dart';

class VocabularyViewModel extends GetxController {
  VocabularyViewModel({required VocabRepository repository})
    : _repository = repository;

  final VocabRepository _repository;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _deviceTts = FlutterTts();

  final RxList<VocabDeckModel> decks = <VocabDeckModel>[].obs;
  final RxList<VocabCardModel> activeCards = <VocabCardModel>[].obs;
  final RxBool isLoadingDecks = false.obs;
  final RxBool isOpeningDeck = false.obs;
  final RxBool isSubmittingReview = false.obs;
  final RxBool isCardFront = true.obs;
  final RxBool isHintVisible = false.obs;
  final RxBool isSpeaking = false.obs;
  final Rxn<VocabDeckModel> activeDeck = Rxn<VocabDeckModel>();
  final RxInt reviewSessionCount = 0.obs;

  VocabCardModel? get currentCard =>
      activeCards.isEmpty ? null : activeCards.first;

  int get totalMasteredCount => decks.fold<int>(
    0,
    (int total, VocabDeckModel deck) => total + deck.masteredCount,
  );

  int get totalDeckCount => decks.length;

  int get totalDueCount => decks.fold<int>(
    0,
    (int total, VocabDeckModel deck) => total + deck.dueWordsCount,
  );

  double get currentReviewProgress {
    if (reviewSessionCount.value == 0) {
      return activeCards.isEmpty ? 1 : 0;
    }

    return ((reviewSessionCount.value - activeCards.length) /
            reviewSessionCount.value)
        .clamp(0.0, 1.0);
  }

  String get currentReviewLabel {
    if (reviewSessionCount.value == 0) {
      return AppStrings.vocabularyDeckCompleted;
    }

    final int reviewedCount = reviewSessionCount.value - activeCards.length;
    return '$reviewedCount/${reviewSessionCount.value}';
  }

  @override
  void onInit() {
    super.onInit();
    _configureAudioPlayer();
    unawaited(_configureDeviceTts());
    unawaited(loadDecks());
  }

  @override
  void onClose() {
    unawaited(_audioPlayer.dispose());
    unawaited(_deviceTts.stop());
    super.onClose();
  }

  Future<void> loadDecks() async {
    isLoadingDecks.value = true;
    try {
      decks.assignAll(await _repository.fetchDecks());
    } on ApiException catch (error) {
      decks.clear();
      ScenioAlert.show(
        title: AppStrings.appName,
        message: error.message,
        isError: true,
      );
    } catch (_) {
      decks.clear();
      ScenioAlert.show(
        title: AppStrings.appName,
        message: 'Chưa thể tải danh sách từ vựng lúc này.',
        isError: true,
      );
    } finally {
      isLoadingDecks.value = false;
    }
  }

  Future<void> openDeck(VocabDeckModel deck) async {
    if (isOpeningDeck.value || isSubmittingReview.value) {
      return;
    }

    isOpeningDeck.value = true;
    activeDeck.value = deck;
    isCardFront.value = true;
    isHintVisible.value = false;

    try {
      final List<VocabCardModel> cards = await _repository.fetchDeckCards(
        deck.id,
      );
      final List<VocabCardModel> dueCards = cards
          .where((VocabCardModel card) => !card.isMastered)
          .toList();
      activeCards.assignAll(dueCards);
      reviewSessionCount.value = dueCards.length;

      await Get.dialog<void>(
        const VocabularyFlashcardStage(),
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.56),
      );
    } on ApiException catch (error) {
      ScenioAlert.show(
        title: AppStrings.appName,
        message: error.message,
        isError: true,
      );
    } catch (_) {
      ScenioAlert.show(
        title: AppStrings.appName,
        message: 'Chưa thể tải danh sách từ vựng trong bộ này.',
        isError: true,
      );
    } finally {
      await _stopSpeaking();
      _resetStageState();
      isOpeningDeck.value = false;
    }

    await loadDecks();
  }

  void toggleCardFace() {
    if (currentCard == null) return;
    isCardFront.value = !isCardFront.value;
    if (isCardFront.value) {
      isHintVisible.value = false;
      unawaited(_speakCurrentWordDelayed());
    }
  }

  void toggleHint() {
    if (currentCard == null) return;
    isHintVisible.value = !isHintVisible.value;
  }

  Future<void> speakCurrentWord() async {
    final VocabCardModel? card = currentCard;
    if (card == null) return;

    try {
      isSpeaking.value = true;
      await _audioPlayer.stop();
      await _deviceTts.stop();
      final bytes = await _repository.fetchPronunciationAudio(card.word);

      // Write bytes to a local temporary file with .mp3 extension to resolve iOS AVPlayer codec issue
      final directory = await getTemporaryDirectory();
      final String filename = 'vocab_${card.id}_${DateTime.now().millisecondsSinceEpoch}.mp3';
      final file = File('${directory.path}/$filename');
      await file.writeAsBytes(bytes);

      await _audioPlayer.play(DeviceFileSource(file.path));
    } catch (_) {
      final bool fallbackSpoken = await _speakWithDeviceTts(card.word);
      if (!fallbackSpoken) {
        isSpeaking.value = false;
        ScenioAlert.show(
          title: AppStrings.appName,
          message: AppStrings.vocabularySpeechError,
          icon: Icons.volume_off_rounded,
          isError: true,
        );
      }
    }
  }

  Future<void> markCurrentCardHard() async {
    if (currentCard == null || isSubmittingReview.value) {
      return;
    }

    final VocabCardModel card = activeCards.removeAt(0);
    activeCards.add(card);
    isCardFront.value = true;
    isHintVisible.value = false;
    await _speakCurrentWordDelayed();
  }

  Future<void> markCurrentCardDone() async {
    final VocabCardModel? card = currentCard;
    final VocabDeckModel? deck = activeDeck.value;

    if (card == null || deck == null || isSubmittingReview.value) {
      return;
    }

    final List<VocabCardModel> previousCards = activeCards.toList();
    final VocabDeckModel previousDeck = deck;
    isSubmittingReview.value = true;

    activeCards.removeAt(0);
    final VocabDeckModel updatedDeck = deck.copyWith(
      masteredCount: deck.masteredCount + 1,
      dueWordsCount: math.max(0, deck.dueWordsCount - 1),
    );
    activeDeck.value = updatedDeck;
    _replaceDeck(updatedDeck);
    isCardFront.value = true;
    isHintVisible.value = false;

    await _speakCurrentWordDelayed();

    try {
      await _repository.markWordAsDone(card.id);
    } catch (_) {
      activeCards.assignAll(previousCards);
      activeDeck.value = previousDeck;
      _replaceDeck(previousDeck);
      ScenioAlert.show(
        title: AppStrings.appName,
        message: AppStrings.vocabularyReviewError,
        icon: Icons.error_outline_rounded,
        isError: true,
      );
      await _speakCurrentWordDelayed();
    } finally {
      isSubmittingReview.value = false;
    }
  }

  Future<void> closeDeckStage() async {
    await _stopSpeaking();
    if (Get.isDialogOpen ?? false) {
      Get.back<void>();
    }
  }

  Future<void> _stopSpeaking() async {
    try {
      await _audioPlayer.stop();
      await _deviceTts.stop();
    } catch (_) {
      // Ignore stop failures from audio player.
    } finally {
      isSpeaking.value = false;
    }
  }

  void _configureAudioPlayer() {
    _audioPlayer.onPlayerComplete.listen((_) {
      isSpeaking.value = false;
    });
  }

  Future<void> _configureDeviceTts() async {
    await _deviceTts.setLanguage('en-US');
    await _deviceTts.setSpeechRate(0.42);
    await _deviceTts.setPitch(1.0);
    await _deviceTts.awaitSpeakCompletion(true);
    _deviceTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });
    _deviceTts.setCancelHandler(() {
      isSpeaking.value = false;
    });
    _deviceTts.setErrorHandler((_) {
      isSpeaking.value = false;
    });
  }

  Future<bool> _speakWithDeviceTts(String text) async {
    final String normalized = text.trim();
    if (normalized.isEmpty) return false;

    try {
      await _deviceTts.speak(normalized);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _speakCurrentWordDelayed() async {
    if (currentCard == null) return;
    await Future<void>.delayed(const Duration(milliseconds: 140));
    await speakCurrentWord();
  }

  void _replaceDeck(VocabDeckModel deck) {
    final int index = decks.indexWhere(
      (VocabDeckModel item) => item.id == deck.id,
    );
    if (index == -1) return;
    decks[index] = deck;
  }

  void _resetStageState() {
    activeCards.clear();
    activeDeck.value = null;
    reviewSessionCount.value = 0;
    isCardFront.value = true;
    isHintVisible.value = false;
  }
}
