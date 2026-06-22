import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/validators/api_key_validator.dart';

/// Editable API key field with masked display and inline validation.
class ApiKeyField extends StatefulWidget {
  final String providerKey;
  final String label;
  final String storedKey;
  final Future<bool> Function(String value) onSave;

  const ApiKeyField({
    super.key,
    required this.providerKey,
    required this.label,
    required this.storedKey,
    required this.onSave,
  });

  @override
  State<ApiKeyField> createState() => _ApiKeyFieldState();
}

class _ApiKeyFieldState extends State<ApiKeyField> {
  late final TextEditingController _controller;
  bool _isEditing = false;
  bool _obscureText = true;
  bool _isSaving = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didUpdateWidget(ApiKeyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.storedKey != widget.storedKey) {
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasStoredKey = widget.storedKey.isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (hasStoredKey && !_isEditing)
                TextButton(
                  onPressed: _startEditing,
                  child: const Text(AppStrings.settingsEditKey),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing8),
          if (_isEditing || !hasStoredKey) ...[
            AppTextField(
              controller: _controller,
              hint: AppStrings.settingsEnterApiKey,
              obscureText: _obscureText,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              ),
            ),
            if (_validationError != null) ...[
              const SizedBox(height: AppSpacing.spacing4),
              Text(
                _validationError!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.spacing12),
            Row(
              children: [
                if (hasStoredKey)
                  TextButton(
                    onPressed: _isSaving ? null : _cancelEditing,
                    child: const Text(AppStrings.cancel),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : const Text(AppStrings.settingsSaveKey),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.spacing8),
                Expanded(
                  child: Text(
                    ApiKeyValidator.mask(widget.storedKey),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _controller.text = widget.storedKey;
      _validationError = null;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _controller.clear();
      _validationError = null;
    });
  }

  Future<void> _save() async {
    final value = _controller.text.trim();
    final validation = ApiKeyValidator.validate(
      providerKey: widget.providerKey,
      apiKey: value,
    );

    String? errorMessage;
    validation.fold(
      (_) {},
      (error) => errorMessage = error.message,
    );

    if (errorMessage != null) {
      setState(() => _validationError = errorMessage);
      return;
    }

    setState(() => _isSaving = true);

    final success = await widget.onSave(value);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      if (success) {
        _isEditing = false;
        _controller.clear();
        _validationError = null;
      }
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.settingsApiKeySaved)),
      );
    }
  }
}
