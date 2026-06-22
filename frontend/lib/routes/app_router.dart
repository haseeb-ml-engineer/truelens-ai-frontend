import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deepshield_ai/features/splash/presentation/screens/splash_screen.dart';
import 'package:deepshield_ai/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:deepshield_ai/features/authentication/presentation/screens/login_screen.dart';
import 'package:deepshield_ai/features/authentication/presentation/screens/signup_screen.dart';
import 'package:deepshield_ai/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:deepshield_ai/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:deepshield_ai/features/upload/presentation/screens/upload_screen.dart';
import 'package:deepshield_ai/features/analysis/presentation/screens/processing_screen.dart';
import 'package:deepshield_ai/features/analysis/presentation/screens/results_screen.dart';
import 'package:deepshield_ai/features/history/presentation/screens/history_screen.dart';
import 'package:deepshield_ai/features/reports/presentation/screens/report_details_screen.dart';
import 'package:deepshield_ai/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:deepshield_ai/features/profile/presentation/screens/profile_screen.dart';
import 'package:deepshield_ai/features/settings/presentation/screens/settings_screen.dart';
import '../widgets/ds_bottom_nav.dart';

/// Route path constants.
class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String upload = '/upload';
  static const String processing = '/processing';
  static const String results = '/results/:scanId';
  static const String history = '/history';
  static const String reportDetails = '/report/:scanId';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

/// Route name constants for named navigation.
class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String signUp = 'signUp';
  static const String forgotPassword = 'forgotPassword';
  static const String dashboard = 'dashboard';
  static const String upload = 'upload';
  static const String processing = 'processing';
  static const String results = 'results';
  static const String history = 'history';
  static const String reportDetails = 'reportDetails';
  static const String notifications = 'notifications';
  static const String profile = 'profile';
  static const String settings = 'settings';
}

// Navigator keys for shell route
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// The app's GoRouter configuration.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutePaths.splash,
  routes: [
    // â”€â”€ Splash â”€â”€
    GoRoute(
      path: RoutePaths.splash,
      name: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // â”€â”€ Onboarding â”€â”€
    GoRoute(
      path: RoutePaths.onboarding,
      name: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // â”€â”€ Auth Routes â”€â”€
    GoRoute(
      path: RoutePaths.login,
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutePaths.signUp,
      name: RouteNames.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: RoutePaths.forgotPassword,
      name: RouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // â”€â”€ Main App Shell (with bottom navigation) â”€â”€
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => DSBottomNavShell(child: child),
      routes: [
        GoRoute(
          path: RoutePaths.dashboard,
          name: RouteNames.dashboard,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.history,
          name: RouteNames.history,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HistoryScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.profile,
          name: RouteNames.profile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),

    // â”€â”€ Upload (full screen, no bottom nav) â”€â”€
    GoRoute(
      path: RoutePaths.upload,
      name: RouteNames.upload,
      builder: (context, state) => const UploadScreen(),
    ),

    // â”€â”€ Processing â”€â”€
    GoRoute(
      path: RoutePaths.processing,
      name: RouteNames.processing,
      builder: (context, state) => const ProcessingScreen(),
    ),

    // â”€â”€ Results â”€â”€
    GoRoute(
      path: RoutePaths.results,
      name: RouteNames.results,
      builder: (context, state) {
        final scanId = state.pathParameters['scanId'] ?? '';
        return ResultsScreen(scanId: scanId);
      },
    ),

    // â”€â”€ Report Details â”€â”€
    GoRoute(
      path: RoutePaths.reportDetails,
      name: RouteNames.reportDetails,
      builder: (context, state) {
        final scanId = state.pathParameters['scanId'] ?? '';
        return ReportDetailsScreen(scanId: scanId);
      },
    ),

    // —— Settings (full screen, no bottom nav) ——
    GoRoute(
      path: RoutePaths.settings,
      name: RouteNames.settings,
      builder: (context, state) => const SettingsScreen(),
    ),

    // â”€â”€ Notifications â”€â”€
    GoRoute(
      path: RoutePaths.notifications,
      name: RouteNames.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],
);