import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:deepshield_ai/core/theme/app_colors.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/core/config/settings_config.dart';
import 'package:deepshield_ai/features/settings/presentation/providers/settings_provider.dart';
import 'package:deepshield_ai/features/authentication/data/models/user_model.dart';
import 'package:deepshield_ai/features/authentication/presentation/providers/auth_provider.dart';
import 'package:deepshield_ai/widgets/ds_app_bar.dart';
import 'package:deepshield_ai/widgets/ds_button.dart';
import 'package:deepshield_ai/widgets/ds_card.dart';

/// Profile and Settings screen allowing users to toggle themes, configure preferences, and manage their subscription.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _pushNotifications = true;
  bool _emailReports = false;
  bool _securityAlerts = true;

  void _showUpgradeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDark : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLarge),
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.spacing24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.spacing20),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing16),
              Text(
                'Upgrade to TrueLens Pro',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing8),
              Text(
                'Unlock unlimited deepfake analysis, priority speed processing, and detailed PDF report downloads.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing24),
              _buildFeatureRow(theme, 'Unlimited image & video scans'),
              _buildFeatureRow(theme, 'Priority GPU processing queue'),
              _buildFeatureRow(theme, 'Deep PDF signal reports'),
              _buildFeatureRow(theme, '24/7 Cybersecurity expert support'),
              const SizedBox(height: AppSpacing.spacing32),
              DSButton.gradient(
                label: 'Upgrade for \$9.99/mo',
                onPressed: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Successfully upgraded to Pro! (Mock simulation)'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.spacing12),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spacing12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureRow(ThemeData theme, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.spacing12),
          Text(
            feature,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user ?? UserModel.mock();
    final theme = Theme.of(context);
    final settingsThemeKey =
        ref.watch(settingsProvider.select((state) => state.settings.themeMode));

    return Scaffold(
      appBar: const DSAppBar(
        title: 'Settings',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.spacing12),

            // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ User Information Header Card ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
            DSCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                    child: Text(
                      user.fullName.split(' ').map((e) => e[0]).take(2).join(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spacing8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.spacing12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: user.plan.toLowerCase() == 'pro'
                                ? AppColors.primaryGradient
                                : null,
                            color: user.plan.toLowerCase() != 'pro'
                                ? theme.colorScheme.surfaceContainerHighest
                                : null,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                          ),
                          child: Text(
                            '${user.plan} Account',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: user.plan.toLowerCase() == 'pro'
                                  ? Colors.white
                                  : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.spacing16),

            // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Simple Stats Row ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
            Row(
              children: [
                Expanded(
                  child: DSCard(
                    padding: const EdgeInsets.all(AppSpacing.spacing12),
                    child: Column(
                      children: [
                        Text(
                          '${user.totalScans}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Total Scans',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: DSCard(
                    padding: const EdgeInsets.all(AppSpacing.spacing12),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('MMM yyyy').format(user.createdAt),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Member Since',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.spacing24),

            // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ App Settings ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
            Text(
              'App Preferences',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            DSCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings_rounded),
                    title: const Text('App Settings'),
                    subtitle: const Text(
                      'Theme, AI provider, API keys, and data',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(RoutePaths.settings),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.dark_mode_rounded),
                    title: const Text('Dark Mode'),
                    subtitle: Text(
                      _isDarkModeActive(context, settingsThemeKey)
                          ? 'Enabled'
                          : 'Disabled',
                    ),
                    trailing: Switch(
                      value: _isDarkModeActive(context, settingsThemeKey),
                      onChanged: (isDark) {
                        ref
                            .read(settingsProvider.notifier)
                            .toggleDarkMode(isDark);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_active_rounded),
                    title: const Text('Push Notifications'),
                    trailing: Switch(
                      value: _pushNotifications,
                      onChanged: (val) => setState(() => _pushNotifications = val),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email_rounded),
                    title: const Text('Email PDF Reports'),
                    trailing: Switch(
                      value: _emailReports,
                      onChanged: (val) => setState(() => _emailReports = val),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security_rounded),
                    title: const Text('Security Alerts'),
                    trailing: Switch(
                      value: _securityAlerts,
                      onChanged: (val) => setState(() => _securityAlerts = val),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.spacing24),

            // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Subscription Management ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
            Text(
              'Billing & Account',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            DSCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.star_rounded, color: Colors.amber),
                    title: const Text('Subscription Plan'),
                    subtitle: Text('Current plan: ${user.plan}'),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () => _showUpgradeDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.receipt_long_rounded),
                    title: const Text('Billing History'),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Billing history not available (Mock)')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.spacing24),

            // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ About and Help ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
            Text(
              'Support & Legal',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            DSCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help_center_rounded),
                    title: const Text('Help & Support Center'),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: const Text('About TrueLens AI'),
                    subtitle: const Text('Version 1.0.0'),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.spacing32),

            // ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ Log Out Button ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬
            DSButton.outline(
              label: 'Sign Out',
              icon: Icons.logout_rounded,
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  // Direct navigation to login
                  context.go(RoutePaths.login);
                }
              },
            ),

            const SizedBox(height: AppSpacing.spacing40),
          ],
        ),
      ),
    );
  }

  bool _isDarkModeActive(BuildContext context, String themeMode) {
    switch (themeMode) {
      case SettingsConfig.themeDark:
        return true;
      case SettingsConfig.themeLight:
        return false;
      case SettingsConfig.themeSystem:
      default:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }
}