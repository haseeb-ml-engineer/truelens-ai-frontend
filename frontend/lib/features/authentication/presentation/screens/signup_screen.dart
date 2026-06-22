import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/core/constants/app_strings.dart';
import 'package:deepshield_ai/features/authentication/presentation/providers/auth_provider.dart';
import 'package:deepshield_ai/utils/validators.dart';
import 'package:deepshield_ai/widgets/ds_button.dart';
import 'package:deepshield_ai/widgets/ds_text_field.dart';

/// Sign-up screen with name, email, password, and confirm password.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authProvider.notifier).signUp(
            _nameController.text.trim(),
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
                    const SizedBox(height: AppSpacing.spacing32),

                    // Back button
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSmall),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.spacing24),

                    // Title
                    Text(
                      'Create Account',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacing8),
                    Text(
                      'Start protecting your digital media today',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.spacing32),

                    // Name field
                    DSTextField(
                      label: AppStrings.fullName,
                      hint: 'John Doe',
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: Validators.name,
                    ),

                    const SizedBox(height: AppSpacing.spacing20),

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
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: Validators.password,
                    ),

                    const SizedBox(height: AppSpacing.spacing20),

                    // Confirm password field
                    DSTextField(
                      label: AppStrings.confirmPassword,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: Validators.confirmPassword(
                        _passwordController.text,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.spacing32),

                    // Sign Up button
                    DSButton.gradient(
                      label: AppStrings.signUp,
                      onPressed: isLoading ? null : _handleSignUp,
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

                    // Login link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAccount,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Text(
                              AppStrings.login,
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