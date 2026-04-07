abstract class AppStrings {
  static const String appName = 'Scenio';

  static const String onboardingTagline = 'Every scene. A new voice.';
  static const String onboardingTitle = 'Practice English in real-world scenes';
  static const String onboardingSubtitle =
      'Step into immersive roleplay conversations and build confidence one scene at a time.';

  static const List<String> onboardingTitles = <String>[
    onboardingTitle,
    'Meet AI partners that respond like real people',
    'Get instant feedback after every reply',
    'Build confidence with a speaking journey that fits you',
  ];

  static const List<String> onboardingSubtitles = <String>[
    onboardingSubtitle,
    'Each scene adapts to your words so the conversation feels natural, dynamic.',
    'Improve grammar, word choice, and fluency with fast suggestions.',
    'Track progress, keep your streak, and unlock the next best scene for your current level.',
  ];

  static const String onboardingComingSoonMessage =
      'Auth flow will be continued in the next step.';
  static const String onboardingPrimaryButton = 'Get Started';
  static const String onboardingSecondaryButton = 'Next';

  static const String onboardingPreviewLabel = 'Preview Image';
  static const String onboardingPreviewCaption =
      'Scene artwork will be attached here later.';

  static const String splashTitle = AppStrings.appName;
  static const String splashSubtitle = AppStrings.onboardingTagline;

  static const String authLoginTitle = 'Sign in to your account';
  static const String authLoginPrompt = 'Don\'t have an account?';
  static const String authLoginPromptAction = 'Sign Up';
  static const String authRegisterTitle = 'Create your account';
  static const String authRegisterPrompt = 'Already have an account?';
  static const String authRegisterPromptAction = 'Log In';

  static const String authIdentifierLabel = 'Email or Username';
  static const String authIdentifierHint = 'Type your email or username';
  static const String authPasswordLabel = 'Password';
  static const String authPasswordHint = 'Type your password';
  static const String authRememberMe = 'Remember me';
  static const String authForgotPassword = 'Forgot Password?';
  static const String authLoginButton = 'Log In';
  static const String authSocialDivider = 'Or continue with';
  static const String authGoogle = 'Google';
  static const String authFacebook = 'Facebook';

  static const String authFirstNameLabel = 'First Name';
  static const String authLastNameLabel = 'Last Name';
  static const String authNameHint = 'Type here';
  static const String authEmailLabel = 'Email';
  static const String authEmailHint = 'Type your email';
  static const String authPhoneLabel = 'Phone Number';
  static const String authPhoneHint = 'Type your phone number';
  static const String authPhoneCode = '+84';
  static const String authRegisterButton = 'Create Account';

  static const String authRequiredFieldMessage = 'This field is required.';
  static const String authInvalidEmailMessage = 'Enter a valid email address.';
  static const String authInvalidPhoneMessage = 'Enter a valid phone number.';
  static const String authPasswordTooShortMessage =
      'Password must be at least 6 characters.';

  static const String authLoginReadyMessage =
      'Login flow UI is ready for API integration.';
  static const String authRegisterReadyMessage =
      'Registration flow UI is ready for API integration.';
  static const String authForgotPasswordMessage =
      'Forgot password flow will be connected next.';
  static const String authGoogleReadyMessage =
      'Google sign-in will be connected next.';
  static const String authFacebookReadyMessage =
      'Facebook sign-in will be connected next.';
}
