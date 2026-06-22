import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_spacing.dart';
import '../core/constants/app_strings.dart';

/// Bottom navigation shell that wraps main app screens.
///
/// Used as the builder for GoRouter's ShellRoute to provide
/// persistent bottom navigation across dashboard, history, and profile.
class DSBottomNavShell extends StatelessWidget {
  final Widget child;

  const DSBottomNavShell({super.key, required this.child});

  // Determine the current index based on the active route.
  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RoutePaths.dashboard);
        break;
      case 1:
        context.go(RoutePaths.history);
        break;
      case 2:
        context.go(RoutePaths.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentIdx = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
              width: 0.5,
            ),
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: AppSpacing.bottomNavHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: AppStrings.navHome,
                  isSelected: currentIdx == 0,
                  onTap: () => _onTap(context, 0),
                  theme: theme,
                ),
                _NavItem(
                  icon: Icons.history_rounded,
                  label: AppStrings.navHistory,
                  isSelected: currentIdx == 1,
                  onTap: () => _onTap(context, 1),
                  theme: theme,
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: AppStrings.navProfile,
                  isSelected: currentIdx == 2,
                  onTap: () => _onTap(context, 2),
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppSpacing.animFast,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing12,
                vertical: AppSpacing.spacing4,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconDefault,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
