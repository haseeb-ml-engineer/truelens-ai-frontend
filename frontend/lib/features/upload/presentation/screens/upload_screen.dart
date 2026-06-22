import 'dart:io';

import 'package:deepshield_ai/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:deepshield_ai/core/theme/app_colors.dart';
import 'package:deepshield_ai/core/theme/app_spacing.dart';
import 'package:deepshield_ai/core/constants/app_strings.dart';
import 'package:deepshield_ai/features/upload/data/services/media_picker_service.dart';
import 'package:deepshield_ai/features/upload/domain/entities/selected_media_file.dart';
import 'package:deepshield_ai/features/upload/presentation/providers/upload_provider.dart';
import 'package:deepshield_ai/utils/helpers.dart';
import 'package:deepshield_ai/widgets/ds_app_bar.dart';
import 'package:deepshield_ai/widgets/ds_button.dart';
import 'package:deepshield_ai/widgets/ds_file_picker_card.dart';

/// Unified Upload screen supporting both image and video file selection.
class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final choice = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text(AppStrings.selectImage),
              onTap: () => Navigator.of(context).pop(false),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text(AppStrings.selectVideo),
              onTap: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ),
    );

    if (!mounted || choice == null) return;

    try {
      if (choice) {
        await ref.read(uploadProvider.notifier).pickVideo();
      } else {
        await ref.read(uploadProvider.notifier).pickImage();
      }
    } on MediaPickerException catch (error) {
      if (mounted) {
        Helpers.showSnackBar(context, error.message, isError: true);
      }
      return;
    }

    if (!mounted) return;
    _beginAnalysis();
  }

  void _removeFile() {
    ref.read(uploadProvider.notifier).clearSelection();
  }

  void _beginAnalysis() {
    final request = ref.read(uploadProvider.notifier).buildAnalysisRequest();
    if (request == null) return;
    context.push(RoutePaths.processing);
  }

  void _startAnalysis() => _beginAnalysis();

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedFile = ref.watch(uploadProvider);
    final hasFile = selectedFile != null;

    return Scaffold(
      appBar: DSAppBar(
        title: AppStrings.uploadTitle,
        actions: [
          if (hasFile)
            TextButton(
              onPressed: _removeFile,
              child: Text(
                'Clear',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.spacing24),

              // File picker area
              Expanded(
                child: Column(
                  children: [
                    DSFilePickerCard(
                      onTap: hasFile ? _removeFile : _pickFile,
                      title: 'Tap to select a file',
                      subtitle: 'Supports JPG, PNG, WebP, MP4, MOV, AVI',
                      icon: Icons.cloud_upload_rounded,
                      hasFile: hasFile,
                      filePreview: hasFile
                          ? _FilePreview(file: selectedFile)
                          : null,
                    ),

                    if (hasFile) ...[
                      const SizedBox(height: AppSpacing.spacing16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.spacing16),
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMedium),
                          border: isDark
                              ? Border.all(
                                  color: theme.colorScheme.outline
                                      .withValues(alpha: 0.15),
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selectedFile.isVideo
                                  ? Icons.videocam_rounded
                                  : Icons.image_rounded,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.spacing12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedFile.fileName,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _formatFileSize(selectedFile.fileSize),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.riskLow,
                            ),
                          ],
                        ),
                      ),
                    ],

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.spacing24,
                      ),
                      child: DSButton.gradient(
                        label: hasFile
                            ? AppStrings.analyze
                            : AppStrings.upload,
                        icon: hasFile
                            ? Icons.auto_awesome_rounded
                            : Icons.cloud_upload_rounded,
                        onPressed: hasFile ? _startAnalysis : _pickFile,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilePreview extends StatelessWidget {
  final SelectedMediaFile file;

  const _FilePreview({required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (file.isVideo) {
      return Container(
        height: 250,
        width: double.infinity,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_rounded,
                size: 56,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppSpacing.spacing8),
              Text(
                file.fileName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Image.file(
      File(file.filePath),
      height: 250,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 250,
          width: double.infinity,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.image_rounded,
            size: 56,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
        );
      },
    );
  }
}
