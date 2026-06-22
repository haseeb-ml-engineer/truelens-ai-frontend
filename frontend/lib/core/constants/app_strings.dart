/// All user-facing strings used throughout the app.
///
/// Centralizing strings makes localization easier later.
class AppStrings {
  AppStrings._();

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // App Info
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String appName = 'TrueLens AI';
  static const String appTagline = 'AI-Powered Deepfake Detection';
  static const String appVersion = '1.0.0';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Onboarding
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String onboardingTitle1 = 'Detect AI-Generated Images';
  static const String onboardingDesc1 =
      'Upload any image and let our advanced AI analyze it for signs of manipulation, deepfakes, and synthetic generation.';

  static const String onboardingTitle2 = 'Detect AI-Generated Videos';
  static const String onboardingDesc2 =
      'Analyze video content frame-by-frame to identify deepfake artifacts, face swaps, and AI-generated sequences.';

  static const String onboardingTitle3 = 'Secure Digital Media';
  static const String onboardingDesc3 =
      'Protect your digital integrity with detailed reports, risk assessments, and actionable recommendations.';

  static const String skip = 'Skip';
  static const String next = 'Next';
  static const String getStarted = 'Get Started';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Authentication
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String login = 'Log In';
  static const String signUp = 'Sign Up';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String continueWithGoogle = 'Continue with Google';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String resetPasswordDesc =
      'Enter your email address and we\'ll send you a link to reset your password.';
  static const String sendResetLink = 'Send Reset Link';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Dashboard
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String welcomeBack = 'Welcome back,';
  static const String recentScans = 'Recent Scans';
  static const String statistics = 'Statistics';
  static const String totalScans = 'Total Scans';
  static const String threatsDetected = 'Threats Detected';
  static const String safeFiles = 'Safe Files';
  static const String accuracy = 'Accuracy';
  static const String uploadImage = 'Upload Image';
  static const String uploadVideo = 'Upload Video';
  static const String scanHistory = 'Scan History';
  static const String quickActions = 'Quick Actions';
  static const String viewAll = 'View All';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Upload
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String uploadTitle = 'Upload Media';
  static const String selectImage = 'Select Image';
  static const String selectVideo = 'Select Video';
  static const String dragAndDrop = 'Drag & drop or tap to upload';
  static const String supportedFormats = 'Supports JPG, PNG, MP4, MOV';
  static const String analyze = 'Analyze';
  static const String upload = 'Upload';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Processing
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String processing = 'Processing';
  static const String analyzingMedia = 'Analyzing your media...';
  static const String stepUploading = 'Uploading file...';
  static const String stepDetectingFaces = 'Detecting faces...';
  static const String stepAnalyzingArtifacts = 'Analyzing artifacts...';
  static const String stepRunningModel = 'Running AI model...';
  static const String stepGeneratingReport = 'Generating report...';

  // Pipeline stage labels (real processing flow)
  static const String pipelineUploading = 'Uploading media';
  static const String pipelineValidating = 'Validating file';
  static const String pipelinePrompt = 'Generating forensic prompt';
  static const String pipelineAnalysis = 'Running AI analysis';
  static const String pipelineParsing = 'Parsing & validating results';
  static const String pipelineFinalizing = 'Finalizing report';
  static const String pipelineComplete = 'Analysis complete';
  static const String pipelineFailed = 'Analysis failed';
  static const String pipelinePreparing = 'Preparing analysis...';
  static const String retryAnalysis = 'Retry Analysis';
  static const String overallProgress = 'Overall Progress';

  // ——————————————————————————————————————————————————————————————
  // Results
  // ——————————————————————————————————————————————————————————————

  static const String analysisReport = 'Analysis Report';
  static const String aiProbability = 'AI Probability';
  static const String confidenceScore = 'Confidence Score';
  static const String riskLevel = 'Risk Level';
  static const String processingTime = 'Processing Time';
  static const String suspiciousIndicators = 'Suspicious Indicators';
  static const String recommendation = 'Recommendation';
  static const String heatmap = 'Heatmap Analysis';
  static const String downloadReport = 'Download Report';
  static const String shareReport = 'Share Report';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Risk Levels
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String riskLow = 'Low';
  static const String riskMedium = 'Medium';
  static const String riskHigh = 'High';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // History
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String history = 'History';
  static const String searchScans = 'Search scans...';
  static const String filterAll = 'All';
  static const String filterImages = 'Images';
  static const String filterVideos = 'Videos';
  static const String noScansYet = 'No scans yet';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Profile
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String profile = 'Profile';
  static const String subscription = 'Subscription';
  static const String settings = 'Settings';
  static const String appearance = 'Appearance';
  static const String darkMode = 'Dark Mode';
  static const String notifications = 'Notifications';
  static const String privacy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
  static const String helpCenter = 'Help Center';
  static const String about = 'About';
  static const String logout = 'Log Out';
  static const String freePlan = 'Free Plan';
  static const String proPlan = 'Pro Plan';
  static const String upgradePlan = 'Upgrade Plan';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Navigation
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String navHome = 'Home';
  static const String navUpload = 'Upload';
  static const String navHistory = 'History';
  static const String navProfile = 'Profile';

  // ——————————————————————————————————————————————————————————————
  // Settings
  // ——————————————————————————————————————————————————————————————

  static const String settingsTitle = 'Settings';
  static const String settingsAppearance = 'Appearance';
  static const String settingsThemeMode = 'Theme';
  static const String settingsThemeLight = 'Light';
  static const String settingsThemeDark = 'Dark';
  static const String settingsThemeSystem = 'System';
  static const String settingsAiProvider = 'AI Provider';
  static const String settingsAiProviderSubtitle =
      'Choose the model that powers your analysis';
  static const String settingsApiKeys = 'API Keys';
  static const String settingsApiKeysSubtitle =
      'Keys are stored locally on your device';
  static const String settingsGeminiKey = 'Gemini API Key';
  static const String settingsOpenAiKey = 'OpenAI API Key';
  static const String settingsClaudeKey = 'Claude API Key';
  static const String settingsEnterApiKey = 'Enter your API key';
  static const String settingsApiKeySaved = 'API key saved successfully';
  static const String settingsApiKeyInvalid = 'Invalid API key';
  static const String settingsAbout = 'About';
  static const String settingsVersion = 'Version';
  static const String settingsClearHistory = 'Clear History';
  static const String settingsClearHistorySubtitle =
      'Permanently delete all saved analyses';
  static const String settingsClearHistoryConfirmTitle = 'Clear History?';
  static const String settingsClearHistoryConfirmMessage =
      'This will permanently delete all saved analysis history. This action cannot be undone.';
  static const String settingsClearHistorySuccess = 'History cleared';
  static const String settingsClearHistoryFailed = 'Failed to clear history';
  static const String settingsTrueLensNoKey = 'No API key required';
  static const String settingsLoading = 'Loading settings...';
  static const String settingsSaveKey = 'Save Key';
  static const String settingsShowKey = 'Show';
  static const String settingsHideKey = 'Hide';
  static const String settingsEditKey = 'Edit';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // General
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
  static const String error = 'Something went wrong';
  static const String noData = 'No data available';
}