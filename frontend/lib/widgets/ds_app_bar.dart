import 'package:flutter/material.dart';
import '../core/theme/app_spacing.dart';

/// A custom app bar for TrueLens screens.
///
/// Supports transparent background, gradient overlay, and
/// custom leading/trailing actions.
class DSAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool transparent;
  final Widget? leading;

  const DSAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.transparent = false,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: transparent ? Colors.transparent : null,
      elevation: 0,
      scrolledUnderElevation: transparent ? 0 : 0.5,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(AppSpacing.spacing6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              : null),
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null),
      actions: actions != null
          ? [...actions!, const SizedBox(width: AppSpacing.spacing8)]
          : null,
    );
  }
}