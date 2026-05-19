import 'package:get/get.dart';

abstract class AppStrings {
  static const String appName = 'Scenio';
  static const String logoOnboardingAsset = 'assets/logo/logo-onboarding.svg';

  static String get onboardingTagline => 'onboardingTagline'.tr;
  static String get onboardingTitle => 'onboardingTitle'.tr;
  static String get onboardingSubtitle => 'onboardingSubtitle'.tr;

  static List<String> get onboardingTitles => <String>[
    onboardingTitle,
    'Meet AI partners that respond like real people'.tr,
    'Get instant feedback after every reply'.tr,
    'Build confidence with a speaking journey that fits you'.tr,
  ];

  static List<String> get onboardingSubtitles => <String>[
    onboardingSubtitle,
    'Each scene adapts to your words so the conversation feels natural, dynamic.'
        .tr,
    'Improve grammar, word choice, and fluency with fast suggestions.'.tr,
    'Track progress, keep your streak, and unlock the next best scene for your current level.'
        .tr,
  ];

  static String get onboardingComingSoonMessage =>
      'onboardingComingSoonMessage'.tr;
  static String get onboardingPrimaryButton => 'onboardingPrimaryButton'.tr;
  static String get onboardingSecondaryButton => 'onboardingSecondaryButton'.tr;

  static String get onboardingPreviewLabel => 'onboardingPreviewLabel'.tr;
  static String get onboardingPreviewCaption => 'onboardingPreviewCaption'.tr;

  static String get splashTitle => 'splashTitle'.tr;
  static String get splashSubtitle => 'splashSubtitle'.tr;

  static String get authLoginTitle => 'authLoginTitle'.tr;
  static String get authLoginPrompt => 'authLoginPrompt'.tr;
  static String get authLoginPromptAction => 'authLoginPromptAction'.tr;
  static String get authRegisterTitle => 'authRegisterTitle'.tr;
  static String get authRegisterPrompt => 'authRegisterPrompt'.tr;
  static String get authRegisterPromptAction => 'authRegisterPromptAction'.tr;

  static String get authIdentifierLabel => 'authIdentifierLabel'.tr;
  static String get authIdentifierHint => 'authIdentifierHint'.tr;
  static String get authPasswordLabel => 'authPasswordLabel'.tr;
  static String get authPasswordHint => 'authPasswordHint'.tr;
  static String get authRememberMe => 'authRememberMe'.tr;
  static String get authForgotPassword => 'authForgotPassword'.tr;
  static String get authLoginButton => 'authLoginButton'.tr;
  static String get authFacebook => 'authFacebook'.tr;

  static String get authFirstNameLabel => 'authFirstNameLabel'.tr;
  static String get authLastNameLabel => 'authLastNameLabel'.tr;
  static String get authNameHint => 'authNameHint'.tr;
  static String get authEmailLabel => 'authEmailLabel'.tr;
  static String get authEmailHint => 'authEmailHint'.tr;
  static String get authRegisterStepOneTitle => 'authRegisterStepOneTitle'.tr;
  static String get authRegisterStepOneCaption =>
      'authRegisterStepOneCaption'.tr;
  static String get authRegisterStepTwoTitle => 'authRegisterStepTwoTitle'.tr;
  static String get authRegisterStepTwoCaption =>
      'authRegisterStepTwoCaption'.tr;
  static String get authRegisterStepLabel => 'authRegisterStepLabel'.tr;
  static String get authNextButton => 'authNextButton'.tr;
  static String get authBackButton => 'authBackButton'.tr;
  static String get authRegisterButton => 'authRegisterButton'.tr;
  static String get authLearningGoalLabel => 'authLearningGoalLabel'.tr;
  static String get authStudyFrequencyLabel => 'authStudyFrequencyLabel'.tr;
  static String get authSelfAssessmentLabel => 'authSelfAssessmentLabel'.tr;

  static String get authRequiredFieldMessage => 'authRequiredFieldMessage'.tr;
  static String get authInvalidEmailMessage => 'authInvalidEmailMessage'.tr;
  static String get authInvalidPhoneMessage => 'authInvalidPhoneMessage'.tr;
  static String get authPasswordTooShortMessage =>
      'authPasswordTooShortMessage'.tr;

  static String get authLoginReadyMessage => 'authLoginReadyMessage'.tr;
  static String get authRegisterReadyMessage => 'authRegisterReadyMessage'.tr;
  static String get authLoginSuccessMessage => 'authLoginSuccessMessage'.tr;
  static String get authRegisterSuccessMessage =>
      'authRegisterSuccessMessage'.tr;
  static String get authForgotPasswordMessage => 'authForgotPasswordMessage'.tr;
  static String get authFacebookReadyMessage => 'authFacebookReadyMessage'.tr;
  static String get authLevelTestPendingMessage =>
      'authLevelTestPendingMessage'.tr;

  static String get accountOnboardingEyebrow => 'accountOnboardingEyebrow'.tr;
  static String get accountOnboardingTitle => 'accountOnboardingTitle'.tr;
  static String get accountOnboardingSubtitle => 'accountOnboardingSubtitle'.tr;
  static String get accountOnboardingGoalTitle =>
      'accountOnboardingGoalTitle'.tr;
  static String get accountOnboardingGoalSubtitle =>
      'accountOnboardingGoalSubtitle'.tr;
  static String get accountOnboardingGoalWork => 'accountOnboardingGoalWork'.tr;
  static String get accountOnboardingGoalWorkCaption =>
      'accountOnboardingGoalWorkCaption'.tr;
  static String get accountOnboardingGoalTravel =>
      'accountOnboardingGoalTravel'.tr;
  static String get accountOnboardingGoalTravelCaption =>
      'accountOnboardingGoalTravelCaption'.tr;
  static String get accountOnboardingGoalDaily =>
      'accountOnboardingGoalDaily'.tr;
  static String get accountOnboardingGoalDailyCaption =>
      'accountOnboardingGoalDailyCaption'.tr;
  static String get accountOnboardingGoalMixed =>
      'accountOnboardingGoalMixed'.tr;
  static String get accountOnboardingGoalMixedCaption =>
      'accountOnboardingGoalMixedCaption'.tr;
  static String get accountOnboardingFrequencyTitle =>
      'accountOnboardingFrequencyTitle'.tr;
  static String get accountOnboardingFrequencySubtitle =>
      'accountOnboardingFrequencySubtitle'.tr;
  static String get accountOnboardingFrequencyLight =>
      'accountOnboardingFrequencyLight'.tr;
  static String get accountOnboardingFrequencyLightCaption =>
      'accountOnboardingFrequencyLightCaption'.tr;
  static String get accountOnboardingFrequencyRegular =>
      'accountOnboardingFrequencyRegular'.tr;
  static String get accountOnboardingFrequencyRegularCaption =>
      'accountOnboardingFrequencyRegularCaption'.tr;
  static String get accountOnboardingFrequencyIntensive =>
      'accountOnboardingFrequencyIntensive'.tr;
  static String get accountOnboardingFrequencyIntensiveCaption =>
      'accountOnboardingFrequencyIntensiveCaption'.tr;
  static String get accountOnboardingFocusTitle =>
      'accountOnboardingFocusTitle'.tr;
  static String get accountOnboardingFocusSubtitle =>
      'accountOnboardingFocusSubtitle'.tr;
  static String get accountOnboardingFocusVocabulary =>
      'accountOnboardingFocusVocabulary'.tr;
  static String get accountOnboardingFocusVocabularyCaption =>
      'accountOnboardingFocusVocabularyCaption'.tr;
  static String get accountOnboardingFocusGrammar =>
      'accountOnboardingFocusGrammar'.tr;
  static String get accountOnboardingFocusGrammarCaption =>
      'accountOnboardingFocusGrammarCaption'.tr;
  static String get accountOnboardingFocusNaturalness =>
      'accountOnboardingFocusNaturalness'.tr;
  static String get accountOnboardingFocusNaturalnessCaption =>
      'accountOnboardingFocusNaturalnessCaption'.tr;
  static String get accountOnboardingFocusConfidence =>
      'accountOnboardingFocusConfidence'.tr;
  static String get accountOnboardingFocusConfidenceCaption =>
      'accountOnboardingFocusConfidenceCaption'.tr;
  static String get accountOnboardingSubmitButton =>
      'accountOnboardingSubmitButton'.tr;
  static String get accountOnboardingSavingButton =>
      'accountOnboardingSavingButton'.tr;
  static String get accountOnboardingSuccessMessage =>
      'accountOnboardingSuccessMessage'.tr;

  static String get homeTabHome => 'homeTabHome'.tr;
  static String get homeTabScenes => 'homeTabScenes'.tr;
  static String get homeTabVocabulary => 'homeTabVocabulary'.tr;
  static String get homeTabChat => 'homeTabChat'.tr;
  static String get homeTabProfile => 'homeTabProfile'.tr;
  static String get homeCurrentPageLabel => 'homeCurrentPageLabel'.tr;
  static String get homeGreeting => 'homeGreeting'.tr;
  static String get homeDisplayName => 'homeDisplayName'.tr;
  static String get homeGreetingSubtitle => 'homeGreetingSubtitle'.tr;
  static String get homeContinueLabel => 'homeContinueLabel'.tr;
  static String get homeContinueTitle => 'homeContinueTitle'.tr;
  static String get homeContinueTime => 'homeContinueTime'.tr;
  static String get homeContinueCharacter => 'homeContinueCharacter'.tr;
  static String get homeContinueMeta => 'homeContinueMeta'.tr;
  static String get homeContinueBadgeLabel => 'homeContinueBadgeLabel'.tr;
  static String get homeContinueBadgeValue => 'homeContinueBadgeValue'.tr;
  static String get homeContinueStatusLabel => 'homeContinueStatusLabel'.tr;
  static String get homeContinueStatusValue => 'homeContinueStatusValue'.tr;
  static String get homeMomentumSection => 'homeMomentumSection'.tr;
  static String get homeMissionsSection => 'homeMissionsSection'.tr;
  static String get homeRecommendedSection => 'homeRecommendedSection'.tr;
  static String get homeLearningPlanSection => 'homeLearningPlanSection'.tr;
  static String get homeLearningPlanNextStep => 'homeLearningPlanNextStep'.tr;
  static String get homeLearningPlanRefresh => 'homeLearningPlanRefresh'.tr;
  static String get homeSeeAll => 'homeSeeAll'.tr;
  static String get homeStatXp => 'homeStatXp'.tr;
  static String get homeStatStreak => 'homeStatStreak'.tr;
  static String get homeStatSaved => 'homeStatSaved'.tr;
  static String get homeMissionOneTitle => 'homeMissionOneTitle'.tr;
  static String get homeMissionOneSubtitle => 'homeMissionOneSubtitle'.tr;
  static String get homeMissionTwoTitle => 'homeMissionTwoTitle'.tr;
  static String get homeMissionTwoSubtitle => 'homeMissionTwoSubtitle'.tr;
  static String get homeMissionProgressLabel => 'homeMissionProgressLabel'.tr;
  static String get homeMissionRewardLabel => 'homeMissionRewardLabel'.tr;
  static String get homeSceneOneMeta => 'homeSceneOneMeta'.tr;
  static String get homeSceneTwoMeta => 'homeSceneTwoMeta'.tr;
  static String get homeSceneThreeMeta => 'homeSceneThreeMeta'.tr;

  static String get notificationsTitle => 'notificationsTitle'.tr;
  static String get notificationsMarkAll => 'notificationsMarkAll'.tr;
  static String get notificationsAllFilter => 'notificationsAllFilter'.tr;
  static String get notificationsUnreadFilter => 'notificationsUnreadFilter'.tr;
  static String get notificationsEmptyTitle => 'notificationsEmptyTitle'.tr;
  static String get notificationsEmptyMessage => 'notificationsEmptyMessage'.tr;
  static String get notificationsUnreadEmptyTitle =>
      'notificationsUnreadEmptyTitle'.tr;
  static String get notificationsUnreadEmptyMessage =>
      'notificationsUnreadEmptyMessage'.tr;
  static String get notificationsLoading => 'notificationsLoading'.tr;
  static String get notificationsLoadMore => 'notificationsLoadMore'.tr;
  static String get notificationsLoadError => 'notificationsLoadError'.tr;
  static String get notificationsMarkReadError =>
      'notificationsMarkReadError'.tr;
  static String get notificationsMarkAllSuccess =>
      'notificationsMarkAllSuccess'.tr;
  static String get notificationsMissingSessionError =>
      'notificationsMissingSessionError'.tr;
  static String get notificationsSessionResultError =>
      'notificationsSessionResultError'.tr;
  static String get notificationsNow => 'notificationsNow'.tr;
  static String get notificationsMinuteSuffix => 'notificationsMinuteSuffix'.tr;
  static String get notificationsHourSuffix => 'notificationsHourSuffix'.tr;
  static String get notificationsDaySuffix => 'notificationsDaySuffix'.tr;
  static String get notificationsWeekSuffix => 'notificationsWeekSuffix'.tr;

  static String get homeWelcomeLabel => 'homeWelcomeLabel'.tr;
  static String get homeWelcomeTitle => 'homeWelcomeTitle'.tr;
  static String get homeWelcomeSubtitle => 'homeWelcomeSubtitle'.tr;
  static String get homeResumeCardTitle => 'homeResumeCardTitle'.tr;
  static String get homeResumeCardSubtitle => 'homeResumeCardSubtitle'.tr;
  static String get homeResumeAction => 'homeResumeAction'.tr;
  static String get homeStreakTitle => 'homeStreakTitle'.tr;
  static String get homeFeedbackTitle => 'homeFeedbackTitle'.tr;
  static String get homeScenesSectionTitle => 'homeScenesSectionTitle'.tr;
  static String get homeSceneOneTitle => 'homeSceneOneTitle'.tr;
  static String get homeSceneOneSubtitle => 'homeSceneOneSubtitle'.tr;
  static String get homeSceneTwoTitle => 'homeSceneTwoTitle'.tr;
  static String get homeSceneTwoSubtitle => 'homeSceneTwoSubtitle'.tr;
  static String get homeSceneThreeTitle => 'homeSceneThreeTitle'.tr;
  static String get homeSceneThreeSubtitle => 'homeSceneThreeSubtitle'.tr;

  static String get homeChatTitle => 'homeChatTitle'.tr;
  static String get homeChatSubtitle => 'homeChatSubtitle'.tr;
  static String get homeChatAction => 'homeChatAction'.tr;

  static String get homeProfileTitle => 'homeProfileTitle'.tr;
  static String get homeProfileSubtitle => 'homeProfileSubtitle'.tr;
  static String get homeProfileLevel => 'homeProfileLevel'.tr;
  static String get homeProfileHistory => 'homeProfileHistory'.tr;
  static String get homeProfileSaved => 'homeProfileSaved'.tr;
  static String get homeProfileGoal => 'homeProfileGoal'.tr;

  static String get profileEmail => 'profileEmail'.tr;
  static String get profileHeroEdit => 'profileHeroEdit'.tr;
  static String get profileHeroGoal => 'profileHeroGoal'.tr;
  static String get profileHeroFrequency => 'profileHeroFrequency'.tr;
  static String get profileHeroFocus => 'profileHeroFocus'.tr;
  static String get profileGoalProgressValue => 'profileGoalProgressValue'.tr;
  static String get profileBadgesProgressValue =>
      'profileBadgesProgressValue'.tr;

  static String get profileOverviewSection => 'profileOverviewSection'.tr;
  static String get profileWeeklyXpSection => 'profileWeeklyXpSection'.tr;
  static String get profileWeeklyXpCaption => 'profileWeeklyXpCaption'.tr;
  static String get profileSkillBreakdownSection =>
      'profileSkillBreakdownSection'.tr;
  static String get profileBadgesSection => 'profileBadgesSection'.tr;
  static String get profileBadgesEarnedLabel => 'profileBadgesEarnedLabel'.tr;
  static String get profileHistorySection => 'profileHistorySection'.tr;
  static String get profileAccountSection => 'profileAccountSection'.tr;
  static String get profileViewAll => 'profileViewAll'.tr;

  static String get profileStatXpLabel => 'profileStatXpLabel'.tr;
  static String get profileStatXpSubtitle => 'profileStatXpSubtitle'.tr;
  static String get profileStatStreakLabel => 'profileStatStreakLabel'.tr;
  static String get profileStatStreakSubtitle => 'profileStatStreakSubtitle'.tr;
  static String get profileStatSessionsLabel => 'profileStatSessionsLabel'.tr;
  static String get profileStatSessionsSubtitle =>
      'profileStatSessionsSubtitle'.tr;
  static String get profileStatSavedLabel => 'profileStatSavedLabel'.tr;
  static String get profileStatSavedSubtitle => 'profileStatSavedSubtitle'.tr;

  static String get profileSkillGrammar => 'profileSkillGrammar'.tr;
  static String get profileSkillVocabulary => 'profileSkillVocabulary'.tr;
  static String get profileSkillNaturalness => 'profileSkillNaturalness'.tr;

  static String get profileBadgeFirstSceneTitle =>
      'profileBadgeFirstSceneTitle'.tr;
  static String get profileBadgeFirstSceneDescription =>
      'profileBadgeFirstSceneDescription'.tr;
  static String get profileBadgeSevenDayTitle => 'profileBadgeSevenDayTitle'.tr;
  static String get profileBadgeSevenDayDescription =>
      'profileBadgeSevenDayDescription'.tr;
  static String get profileBadgeCollectorTitle =>
      'profileBadgeCollectorTitle'.tr;
  static String get profileBadgeCollectorDescription =>
      'profileBadgeCollectorDescription'.tr;

  static String get profileHistoryAirportTitle =>
      'profileHistoryAirportTitle'.tr;
  static String get profileHistoryAirportMeta => 'profileHistoryAirportMeta'.tr;
  static String get profileHistoryCafeTitle => 'profileHistoryCafeTitle'.tr;
  static String get profileHistoryCafeMeta => 'profileHistoryCafeMeta'.tr;
  static String get profileHistoryMeetingTitle =>
      'profileHistoryMeetingTitle'.tr;
  static String get profileHistoryMeetingMeta => 'profileHistoryMeetingMeta'.tr;

  static String get profileActionSavedWords => 'profileActionSavedWords'.tr;
  static String get profileActionSavedWordsSubtitle =>
      'profileActionSavedWordsSubtitle'.tr;
  static String get profileActionNotifications =>
      'profileActionNotifications'.tr;
  static String get profileActionNotificationsSubtitle =>
      'profileActionNotificationsSubtitle'.tr;
  static String get profileActionDailyGoal => 'profileActionDailyGoal'.tr;
  static String get profileActionDailyGoalSubtitle =>
      'profileActionDailyGoalSubtitle'.tr;
  static String get profileActionLogout => 'profileActionLogout'.tr;
  static String get profileActionLogoutSubtitle =>
      'profileActionLogoutSubtitle'.tr;
  static String get profileLogoutSuccessMessage =>
      'profileLogoutSuccessMessage'.tr;

  static String get homeTabPractice => 'homeTabPractice'.tr;
  static String get homeContinueResumeLabel => 'homeContinueResumeLabel'.tr;
  static String get homeContinueStartLabel => 'homeContinueStartLabel'.tr;
  static String get homeContinueStatusActive => 'homeContinueStatusActive'.tr;
  static String get homeContinueStatusReady => 'homeContinueStatusReady'.tr;

  static String get scenesSearchHint => 'scenesSearchHint'.tr;
  static String get scenesRecommendedSection => 'scenesRecommendedSection'.tr;
  static String get scenesLibrarySection => 'scenesLibrarySection'.tr;
  static String get scenesViewDetails => 'scenesViewDetails'.tr;
  static String get scenesStartLabel => 'scenesStartLabel'.tr;
  static String get scenesFilterAll => 'scenesFilterAll'.tr;
  static String get scenesDifficultyAll => 'scenesDifficultyAll'.tr;
  static String get scenesHeroEyebrow => 'scenesHeroEyebrow'.tr;
  static String get scenesHeroSubtitle => 'scenesHeroSubtitle'.tr;
  static String get scenesHeroChipVoice => 'scenesHeroChipVoice'.tr;
  static String get scenesHeroChipLibrary => 'scenesHeroChipLibrary'.tr;
  static String get scenesHeroStatScenes => 'scenesHeroStatScenes'.tr;
  static String get scenesHeroStatActive => 'scenesHeroStatActive'.tr;

  static String get practiceTabTitle => 'practiceTabTitle'.tr;
  static String get practiceResumeTitle => 'practiceResumeTitle'.tr;
  static String get practiceResumeSubtitle => 'practiceResumeSubtitle'.tr;
  static String get practiceResumeButton => 'practiceResumeButton'.tr;
  static String get practiceBrowseScenesButton =>
      'practiceBrowseScenesButton'.tr;
  static String get practiceEmptyTitle => 'practiceEmptyTitle'.tr;
  static String get practiceEmptySubtitle => 'practiceEmptySubtitle'.tr;
  static String get practiceHeroEyebrow => 'practiceHeroEyebrow'.tr;
  static String get practiceHeroSubtitle => 'practiceHeroSubtitle'.tr;
  static String get practiceHeroChipActive => 'practiceHeroChipActive'.tr;
  static String get practiceHeroChipIdle => 'practiceHeroChipIdle'.tr;
  static String get practiceHeroStatTurns => 'practiceHeroStatTurns'.tr;
  static String get practiceHeroStatMode => 'practiceHeroStatMode'.tr;
  static String get practiceMissionLabel => 'practiceMissionLabel'.tr;
  static String get practiceProgressLabel => 'practiceProgressLabel'.tr;
  static String get practiceStateActive => 'practiceStateActive'.tr;

  static String get vocabularyTabTitle => 'vocabularyTabTitle'.tr;
  static String get vocabularyTabSubtitle => 'vocabularyTabSubtitle'.tr;
  static String get vocabularyStickyMastered => 'vocabularyStickyMastered'.tr;
  static String get vocabularyStickyDecks => 'vocabularyStickyDecks'.tr;
  static String get vocabularyStickyDue => 'vocabularyStickyDue'.tr;
  static String get vocabularyEmptyTitle => 'vocabularyEmptyTitle'.tr;
  static String get vocabularyEmptySubtitle => 'vocabularyEmptySubtitle'.tr;
  static String get vocabularyDeckWordsLabel => 'vocabularyDeckWordsLabel'.tr;
  static String get vocabularyDeckDueLabel => 'vocabularyDeckDueLabel'.tr;
  static String get vocabularyDeckDoneLabel => 'vocabularyDeckDoneLabel'.tr;
  static String get vocabularyDeckCompleted => 'vocabularyDeckCompleted'.tr;
  static String get vocabularyStageReadyLabel => 'vocabularyStageReadyLabel'.tr;
  static String get vocabularyStageFlipHint => 'vocabularyStageFlipHint'.tr;
  static String get vocabularyStageShowSample => 'vocabularyStageShowSample'.tr;
  static String get vocabularyStageHideSample => 'vocabularyStageHideSample'.tr;
  static String get vocabularyStagePronunciation =>
      'vocabularyStagePronunciation'.tr;
  static String get vocabularyStageMeaning => 'vocabularyStageMeaning'.tr;
  static String get vocabularyStagePartOfSpeech =>
      'vocabularyStagePartOfSpeech'.tr;
  static String get vocabularyStageExample => 'vocabularyStageExample'.tr;
  static String get vocabularyStageHard => 'vocabularyStageHard'.tr;
  static String get vocabularyStageDone => 'vocabularyStageDone'.tr;
  static String get vocabularyStageCompleteTitle =>
      'vocabularyStageCompleteTitle'.tr;
  static String get vocabularyStageCompleteSubtitle =>
      'vocabularyStageCompleteSubtitle'.tr;
  static String get vocabularyStageCompleteButton =>
      'vocabularyStageCompleteButton'.tr;
  static String get vocabularyReviewError => 'vocabularyReviewError'.tr;
  static String get vocabularySpeechError => 'vocabularySpeechError'.tr;

  static String get sceneDetailMissionTitle => 'sceneDetailMissionTitle'.tr;
  static String get sceneDetailCharacterTitle => 'sceneDetailCharacterTitle'.tr;
  static String get sceneDetailVocabularyTitle =>
      'sceneDetailVocabularyTitle'.tr;
  static String get sceneDetailSceneMetaTitle => 'sceneDetailSceneMetaTitle'.tr;
  static String get sceneDetailFocusRoleplayTitle =>
      'sceneDetailFocusRoleplayTitle'.tr;
  static String get sceneDetailFocusRoleplaySubtitle =>
      'sceneDetailFocusRoleplaySubtitle'.tr;
  static String get sceneDetailFocusMissionTitle =>
      'sceneDetailFocusMissionTitle'.tr;
  static String get sceneDetailFocusVocabTitle =>
      'sceneDetailFocusVocabTitle'.tr;
  static String get sceneDetailFocusVocabFallback =>
      'sceneDetailFocusVocabFallback'.tr;
  static String get sceneDetailStartButton => 'sceneDetailStartButton'.tr;
  static String get sceneDetailContinueButton => 'sceneDetailContinueButton'.tr;
  static String get sceneDetailResumeCurrentButton =>
      'sceneDetailResumeCurrentButton'.tr;
  static String get sceneDetailStartNewButton => 'sceneDetailStartNewButton'.tr;
  static String get sceneDetailConflictTitle => 'sceneDetailConflictTitle'.tr;
  static String get sceneDetailConflictSubtitle =>
      'sceneDetailConflictSubtitle'.tr;
  static String get sceneDetailAiBadge => 'sceneDetailAiBadge'.tr;

  static String get practiceHeaderTitle => 'practiceHeaderTitle'.tr;
  static String get practiceHintButton => 'practiceHintButton'.tr;
  static String get practiceLeaveButton => 'practiceLeaveButton'.tr;
  static String get practiceEndButton => 'practiceEndButton'.tr;
  static String get practiceTranscriptTitle => 'practiceTranscriptTitle'.tr;
  static String get practiceTranscriptShow => 'practiceTranscriptShow'.tr;
  static String get practiceTranscriptHide => 'practiceTranscriptHide'.tr;
  static String get practiceVocabularyTooltip => 'practiceVocabularyTooltip'.tr;
  static String get practiceVocabularyPopupTitle =>
      'practiceVocabularyPopupTitle'.tr;
  static String get practiceVocabularyPopupContext =>
      'practiceVocabularyPopupContext'.tr;
  static String get practiceVocabularySaveAction =>
      'practiceVocabularySaveAction'.tr;
  static String get practiceVocabularySaved => 'practiceVocabularySaved'.tr;
  static String get practiceVocabularySaveError =>
      'practiceVocabularySaveError'.tr;
  static String get practiceCaptionAi => 'practiceCaptionAi'.tr;
  static String get practiceCaptionYou => 'practiceCaptionYou'.tr;
  static String get practiceComposerHint => 'practiceComposerHint'.tr;
  static String get practiceSendLabel => 'practiceSendLabel'.tr;
  static String get practiceVoiceComingSoon => 'practiceVoiceComingSoon'.tr;
  static String get practiceControlHint => 'practiceControlHint'.tr;
  static String get practiceControlMic => 'practiceControlMic'.tr;
  static String get practiceControlEnd => 'practiceControlEnd'.tr;
  static String get practiceStateIdle => 'practiceStateIdle'.tr;
  static String get practiceStateRequestingMic =>
      'practiceStateRequestingMic'.tr;
  static String get practiceStateConnecting => 'practiceStateConnecting'.tr;
  static String get practiceStateListening => 'practiceStateListening'.tr;
  static String get practiceStateUserSpeaking => 'practiceStateUserSpeaking'.tr;
  static String get practiceStateThinking => 'practiceStateThinking'.tr;
  static String get practiceStateSpeaking => 'practiceStateSpeaking'.tr;
  static String get practiceStateReconnecting => 'practiceStateReconnecting'.tr;
  static String get practiceStatePaused => 'practiceStatePaused'.tr;
  static String get practiceStateTyping => 'practiceStateTyping'.tr;
  static String get practiceStateFinishing => 'practiceStateFinishing'.tr;
  static String get practiceStateCompleted => 'practiceStateCompleted'.tr;
  static String get practiceStateVoiceError => 'practiceStateVoiceError'.tr;
  static String get practiceVoiceStatusIdle => 'practiceVoiceStatusIdle'.tr;
  static String get practiceVoiceStatusLive => 'practiceVoiceStatusLive'.tr;
  static String get practiceVoiceStatusMuted => 'practiceVoiceStatusMuted'.tr;
  static String get practiceVoiceReadySnackbar =>
      'practiceVoiceReadySnackbar'.tr;
  static String get practiceVoiceFallbackError =>
      'practiceVoiceFallbackError'.tr;
  static String get practiceHintSnackbar => 'practiceHintSnackbar'.tr;
  static String get practiceVoiceSnackbar => 'practiceVoiceSnackbar'.tr;
  static String get practiceLeaveSnackbar => 'practiceLeaveSnackbar'.tr;

  static String get sessionResultTitle => 'sessionResultTitle'.tr;
  static String get sessionResultSubtitle => 'sessionResultSubtitle'.tr;
  static String get sessionResultXpLabel => 'sessionResultXpLabel'.tr;
  static String get sessionResultScoresTitle => 'sessionResultScoresTitle'.tr;
  static String get sessionResultGrammar => 'sessionResultGrammar'.tr;
  static String get sessionResultVocabulary => 'sessionResultVocabulary'.tr;
  static String get sessionResultNaturalness => 'sessionResultNaturalness'.tr;
  static String get sessionResultTranscriptTitle =>
      'sessionResultTranscriptTitle'.tr;
  static String get sessionResultCoachTitle => 'sessionResultCoachTitle'.tr;
  static String get sessionResultExpression => 'sessionResultExpression'.tr;
  static String get sessionResultClarity => 'sessionResultClarity'.tr;
  static String get sessionResultConfidence => 'sessionResultConfidence'.tr;
  static String get sessionResultStrengthsTitle =>
      'sessionResultStrengthsTitle'.tr;
  static String get sessionResultImprovementsTitle =>
      'sessionResultImprovementsTitle'.tr;
  static String get sessionResultHighlightsTitle =>
      'sessionResultHighlightsTitle'.tr;
  static String get sessionResultNextStepTitle =>
      'sessionResultNextStepTitle'.tr;
  static String get sessionResultNextStepGrammarTitle =>
      'sessionResultNextStepGrammarTitle'.tr;
  static String get sessionResultNextStepVocabularyTitle =>
      'sessionResultNextStepVocabularyTitle'.tr;
  static String get sessionResultNextStepNaturalnessTitle =>
      'sessionResultNextStepNaturalnessTitle'.tr;
  static String get sessionResultNextStepGrammarBody =>
      'sessionResultNextStepGrammarBody'.tr;
  static String get sessionResultNextStepVocabularyBody =>
      'sessionResultNextStepVocabularyBody'.tr;
  static String get sessionResultNextStepNaturalnessBody =>
      'sessionResultNextStepNaturalnessBody'.tr;
  static String get sessionResultNextStepGrammarButton =>
      'sessionResultNextStepGrammarButton'.tr;
  static String get sessionResultNextStepVocabularyButton =>
      'sessionResultNextStepVocabularyButton'.tr;
  static String get sessionResultNextStepNaturalnessButton =>
      'sessionResultNextStepNaturalnessButton'.tr;
  static String get sessionResultPrimaryButton =>
      'sessionResultPrimaryButton'.tr;
  static String get sessionResultSecondaryButton =>
      'sessionResultSecondaryButton'.tr;
}
