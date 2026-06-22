import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/core/constants/app_strings.dart';
import 'package:deepshield_ai/widgets/ds_button.dart';

/// Three-page onboarding flow introducing TrueLens AI's features.
///
/// Each page has an animated illustration, title, and description.
/// Includes Skip, Next, and Get Started buttons.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding data
  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      icon: Icons.image_search_rounded,
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
      gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    ),
    _OnboardingPageData(
      icon: Icons.videocam_rounded,
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
      gradientColors: [Color(0xFF06B6D4), Color(0xFF6366F1)],
    ),
    _OnboardingPageData(
      icon: Icons.security_rounded,
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDesc3,
      gradientColors: [Color(0xFF10B981), Color(0xFF06B6D4)],
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppSpacing.animMedium,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    context.go(RoutePaths.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing20,
                vertical: AppSpacing.spacing12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _navigateToLogin,
                      child: Text(
                        AppStrings.skip,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Page indicator + button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing24),
              child: Column(
                children: [
                  // Page dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: AppSpacing.animFast,
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacing4,
                        ),
                        width: _currentPage == index ? 32 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(alpha: 0.3),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.spacing32),

                  // Action button
                  DSButton.gradient(
                    label: _currentPage == _pages.length - 1
                        ? AppStrings.getStarted
                        : AppStrings.next,
                    icon: _currentPage == _pages.length - 1
                        ? Icons.arrow_forward_rounded
                        : null,
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for a single onboarding page.
class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradientColors;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradientColors,
  });
}

/// A single onboarding page with icon, title, and description.
class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: data.gradientColors
                    .map((c) => c.withValues(alpha: isDark ? 0.2 : 0.12))
                    .toList(),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: data.gradientColors[0].withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                ),
                // Inner circle with icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: data.gradientColors,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: data.gradientColors[0].withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    data.icon,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.spacing48),

          // Title
          Text(
            data.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.spacing16),

          // Description
          Text(
            data.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}