import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/utils/scenio_alerts.dart';
import '../../data/models/custom_practice_model.dart';
import '../../routes/app_routes.dart';
import '../home/home_viewmodel.dart';

class CustomPracticePreset {
  const CustomPracticePreset({
    required this.title,
    required this.subtitle,
    required this.goal,
    required this.topicSummary,
    required this.contextType,
    required this.channel,
    required this.userRole,
    required this.userIntent,
    required this.aiRole,
    required this.aiDisplayName,
    required this.aiGoal,
    required this.aiBehaviorStyle,
    required this.gender,
    required this.tone,
    required this.difficulty,
    this.location = '',
    this.successOutcome = '',
    this.accent = '',
    this.instructions = '',
    this.specialConditions = const <String>[],
  });

  final String title;
  final String subtitle;
  final String goal;
  final String topicSummary;
  final String contextType;
  final String channel;
  final String userRole;
  final String userIntent;
  final String aiRole;
  final String aiDisplayName;
  final String aiGoal;
  final String aiBehaviorStyle;
  final String gender;
  final String tone;
  final String difficulty;
  final String location;
  final String successOutcome;
  final String accent;
  final String instructions;
  final List<String> specialConditions;
}

class CustomPracticeViewModel extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();

  final TextEditingController practiceGoalController = TextEditingController();
  final TextEditingController successOutcomeController =
      TextEditingController();
  final TextEditingController topicSummaryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController userRoleController = TextEditingController();
  final TextEditingController userIntentController = TextEditingController();
  final TextEditingController aiRoleController = TextEditingController();
  final TextEditingController aiDisplayNameController = TextEditingController();
  final TextEditingController aiPrimaryGoalController = TextEditingController();
  final TextEditingController aiBehaviorStyleController =
      TextEditingController();
  final TextEditingController aiAccentController = TextEditingController();
  final TextEditingController customInstructionsController =
      TextEditingController();
  final TextEditingController specialConditionsController =
      TextEditingController();

  final RxString contextType = 'INTERVIEW'.obs;
  final RxString conversationChannel = 'IN_PERSON'.obs;
  final RxString aiGenderPresentation = 'NEUTRAL'.obs;
  final RxString aiVoiceTone = 'FRIENDLY'.obs;
  final RxString difficulty = 'A2'.obs;
  final RxInt currentStep = 0.obs;
  final RxInt revealedStage = 0.obs;
  final RxBool isSubmitting = false.obs;

  int get totalSteps => 4;
  bool get isFirstStep => currentStep.value == 0;
  bool get isLastStep => currentStep.value == totalSteps - 1;

  List<CustomPracticePreset> get presets => const <CustomPracticePreset>[
    CustomPracticePreset(
      title: 'Job interview',
      subtitle: 'HR interview for a frontend intern',
      goal: 'Practice answering a short HR interview with calm structure.',
      topicSummary: 'A first-round HR interview for a frontend intern role.',
      contextType: 'INTERVIEW',
      channel: 'VIDEO_CALL',
      userRole: 'Frontend intern candidate',
      userIntent: 'Show confidence and explain my background clearly.',
      aiRole: 'HR recruiter',
      aiDisplayName: 'Emma',
      aiGoal: 'Assess whether the candidate is a strong fit.',
      aiBehaviorStyle: 'Professional, warm, and slightly challenging.',
      gender: 'FEMALE',
      tone: 'CONFIDENT',
      difficulty: 'B1',
      location: 'Google Meet',
      successOutcome:
          'Finish with a clear self-introduction and one good question.',
      instructions:
          'Correct me mostly at the end unless the reply is very unclear.',
      specialConditions: <String>[
        'short answers first',
        'friendly interviewer',
      ],
    ),
    CustomPracticePreset(
      title: 'Phone call',
      subtitle: 'Call to reschedule a medical appointment',
      goal: 'Practice a polite phone call to change an appointment time.',
      topicSummary: 'A quick phone call with clinic reception.',
      contextType: 'PHONE_CALL',
      channel: 'PHONE_CALL',
      userRole: 'Patient',
      userIntent: 'Ask to move the appointment to another day.',
      aiRole: 'Clinic receptionist',
      aiDisplayName: 'Lina',
      aiGoal: 'Collect the needed details and offer new times.',
      aiBehaviorStyle: 'Calm, clear, and efficient.',
      gender: 'FEMALE',
      tone: 'CALM',
      difficulty: 'A2',
      location: 'On the phone',
      successOutcome:
          'Reschedule the appointment politely without getting lost.',
      instructions: 'Keep the conversation simple and supportive.',
      specialConditions: <String>['slightly nervous caller'],
    ),
    CustomPracticePreset(
      title: 'Travel support',
      subtitle: 'Ask an airline agent to help with a delayed bag',
      goal: 'Explain a baggage issue and ask for help politely.',
      topicSummary: 'Talking to an airline service agent after landing.',
      contextType: 'TRAVEL',
      channel: 'IN_PERSON',
      userRole: 'Passenger',
      userIntent: 'Report a delayed bag and ask what happens next.',
      aiRole: 'Airline service agent',
      aiDisplayName: 'Noah',
      aiGoal: 'Ask for the needed information and explain the process.',
      aiBehaviorStyle: 'Helpful, direct, and a little busy.',
      gender: 'MALE',
      tone: 'FRIENDLY',
      difficulty: 'A2',
      location: 'Airport baggage service desk',
      successOutcome:
          'Report the problem clearly and understand the next steps.',
      instructions: 'Give me realistic follow-up questions from the agent.',
      specialConditions: <String>['a bit of time pressure'],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _applyPreset(presets.first);
    _runEntranceSequence();
  }

  void selectContextType(String value) => contextType.value = value;
  void selectConversationChannel(String value) =>
      conversationChannel.value = value;
  void selectGender(String value) => aiGenderPresentation.value = value;
  void selectTone(String value) => aiVoiceTone.value = value;
  void selectDifficulty(String value) => difficulty.value = value;

  void applyPreset(CustomPracticePreset preset) {
    _applyPreset(preset);
    update();
  }

  void previousStep() {
    if (isFirstStep) return;
    currentStep.value = currentStep.value - 1;
  }

  void nextStep() {
    if (!_validateCurrentStep()) {
      return;
    }

    if (isLastStep) {
      return;
    }

    currentStep.value = currentStep.value + 1;
  }

  Future<void> submit() async {
    if (!_validateAllSteps()) {
      return;
    }

    isSubmitting.value = true;
    final CustomPracticeDraft draft = CustomPracticeDraft(
      practiceGoal: practiceGoalController.text,
      successOutcome: successOutcomeController.text,
      topicSummary: topicSummaryController.text,
      contextType: contextType.value,
      location: locationController.text,
      conversationChannel: conversationChannel.value,
      userRole: userRoleController.text,
      userIntent: userIntentController.text,
      aiRole: aiRoleController.text,
      aiDisplayName: aiDisplayNameController.text,
      aiBehaviorStyle: aiBehaviorStyleController.text,
      aiPrimaryGoal: aiPrimaryGoalController.text,
      aiGenderPresentation: aiGenderPresentation.value,
      aiVoiceTone: aiVoiceTone.value,
      aiAccentPreference: aiAccentController.text,
      difficulty: difficulty.value,
      customInstructions: customInstructionsController.text,
      specialConditions: specialConditionsController.text
          .split(',')
          .map((String item) => item.trim())
          .where((String item) => item.isNotEmpty)
          .toList(),
    );

    final bool started = await homeViewModel.startCustomPracticeSession(draft);
    isSubmitting.value = false;

    if (!started || homeViewModel.currentSession == null) {
      return;
    }

    Get.offNamed(
      Routes.practiceSession,
      arguments: homeViewModel.currentSession!.id,
    );
  }

  String? validateRequired(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) {
      return AppStrings.authRequiredFieldMessage;
    }
    if (text.length < 4) {
      return 'Please add a bit more detail.'.tr;
    }
    return null;
  }

  String? validateOptionalLonger(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    if (text.length < 4) {
      return 'Please add a bit more detail.'.tr;
    }
    return null;
  }

  String stepTitle(int step) {
    switch (step) {
      case 0:
        return 'Goal and outcome'.tr;
      case 1:
        return 'Conversation setup'.tr;
      case 2:
        return 'AI partner'.tr;
      case 3:
      default:
        return 'Learning focus'.tr;
    }
  }

  String stepSubtitle(int step) {
    switch (step) {
      case 0:
        return 'Start with the situation you really want to handle well.'.tr;
      case 1:
        return 'Set the context so the conversation feels believable right away.'
            .tr;
      case 2:
        return 'Shape the AI into the right character before the session starts.'
            .tr;
      case 3:
      default:
        return 'Tune the coaching level, then launch the session.'.tr;
    }
  }

  String get primaryActionLabel =>
      isLastStep ? 'Start custom practice'.tr : 'Continue'.tr;

  Future<void> handlePrimaryAction() async {
    if (isLastStep) {
      await submit();
      return;
    }

    nextStep();
  }

  String get progressLabel =>
      '${'Step'.tr} ${currentStep.value + 1} ${'of'.tr} $totalSteps';

  Future<void> _runEntranceSequence() async {
    revealedStage.value = 0;
    await Future<void>.delayed(const Duration(milliseconds: 80));
    revealedStage.value = 1;
    await Future<void>.delayed(const Duration(milliseconds: 120));
    revealedStage.value = 2;
    await Future<void>.delayed(const Duration(milliseconds: 120));
    revealedStage.value = 3;
  }

  bool _validateCurrentStep() {
    final FormState? form = formKey.currentState;
    if (form != null && !form.validate()) {
      return false;
    }
    return true;
  }

  bool _validateAllSteps() {
    if (_requiredIssue(practiceGoalController.text) != null ||
        _requiredIssue(topicSummaryController.text) != null) {
      currentStep.value = 0;
      _showStepMessage('Please complete the session goal first.'.tr);
      return false;
    }

    if (_requiredIssue(userRoleController.text) != null) {
      currentStep.value = 1;
      _showStepMessage('Please describe your role in the conversation.'.tr);
      return false;
    }

    if (_requiredIssue(aiRoleController.text) != null ||
        _requiredIssue(aiDisplayNameController.text) != null) {
      currentStep.value = 2;
      _showStepMessage('Please define the AI role before continuing.'.tr);
      return false;
    }

    return true;
  }

  String? _requiredIssue(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty || text.length < 4) {
      return AppStrings.authRequiredFieldMessage;
    }
    return null;
  }

  void _showStepMessage(String message) {
    ScenioAlert.show(title: 'Scenio', message: message, isError: true);
  }

  void _applyPreset(CustomPracticePreset preset) {
    practiceGoalController.text = preset.goal;
    successOutcomeController.text = preset.successOutcome;
    topicSummaryController.text = preset.topicSummary;
    locationController.text = preset.location;
    userRoleController.text = preset.userRole;
    userIntentController.text = preset.userIntent;
    aiRoleController.text = preset.aiRole;
    aiDisplayNameController.text = preset.aiDisplayName;
    aiPrimaryGoalController.text = preset.aiGoal;
    aiBehaviorStyleController.text = preset.aiBehaviorStyle;
    aiAccentController.text = preset.accent;
    customInstructionsController.text = preset.instructions;
    specialConditionsController.text = preset.specialConditions.join(', ');
    contextType.value = preset.contextType;
    conversationChannel.value = preset.channel;
    aiGenderPresentation.value = preset.gender;
    aiVoiceTone.value = preset.tone;
    difficulty.value = preset.difficulty;
  }

  @override
  void onClose() {
    practiceGoalController.dispose();
    successOutcomeController.dispose();
    topicSummaryController.dispose();
    locationController.dispose();
    userRoleController.dispose();
    userIntentController.dispose();
    aiRoleController.dispose();
    aiDisplayNameController.dispose();
    aiPrimaryGoalController.dispose();
    aiBehaviorStyleController.dispose();
    aiAccentController.dispose();
    customInstructionsController.dispose();
    specialConditionsController.dispose();
    super.onClose();
  }
}
