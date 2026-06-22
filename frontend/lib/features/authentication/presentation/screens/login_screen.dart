import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deepshield_ai/core/theme/app_colors.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/core/constants/app_strings.dart';
import 'package:deepshield_ai/features/authentication/presentation/providers/auth_provider.dart';
import 'package:deepshield_ai/utils/validators.dart';
import 'package:deepshield_ai/widgets/ds_button.dart';
import 'package:deepshield_ai/widgets/ds_text_field.dart';

/// Login screen with email/password and Google sign-in.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
      if (mounted) {
        final state = ref.read(authProvider);
        if (state.status == AuthStatus.authenticated) {
          context.go(RoutePaths.dashboard);
        }
      }
    }
  }

  void _handleGoogleSignIn() async {
    await ref.read(authProvider.notifier).signInWithGoogle();
    if (mounted) {
      final state = ref.read(authProvider);
      if (state.status == AuthStatus.authenticated) {
        context.go(RoutePaths.dashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.spacing48),

                    // Logo
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLarge),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryLight
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shield_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.spacing32),

                    // Title
                    Center(
                      child: Text(
                        'Welcome Back',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacing8),
                    Center(
                      child: Text(
                        'Sign in to continue protecting digital media',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.spacing40),

                    // Email field
                    DSTextField(
                      label: AppStrings.email,
                      hint: 'you@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                    ),

                    const SizedBox(height: AppSpacing.spacing20),

                    // Password field
                    DSTextField(
                      label: AppStrings.password,
                      controller: _passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: Validators.password,
                    ),

                    const SizedBox(height: AppSpacing.spacing12),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(RoutePaths.forgotPassword),
                        child: Text(
                          AppStrings.forgotPassword,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.spacing24),

                    // Login button
                    DSButton.gradient(
                      label: AppStrings.login,
                      onPressed: isLoading ? null : _handleLogin,
                      isLoading: isLoading,
                    ),

                    const SizedBox(height: AppSpacing.spacing24),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.spacing16,
                          ),
                          child: Text(
                            'or',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.spacing24),

                    // Google Sign-In button
                    DSButton.outline(
                      label: AppStrings.continueWithGoogle,
                      icon: Icons.g_mobiledata_rounded,
                      onPressed: isLoading ? null : _handleGoogleSignIn,
                    ),

                    const SizedBox(height: AppSpacing.spacing32),

                    // Sign up link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.dontHaveAccount,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push(RoutePaths.signUp),
                            child: Text(
                              AppStrings.signUp,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.spacing32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}