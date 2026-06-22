import 'package:flutter/material.dart';

/// The execution status of a single pipeline stage.
enum StageStatus {
  /// The stage has not yet started.
  pending,

  /// The stage is currently executing.
  active,

  /// The stage completed successfully.
  completed,

  /// The stage encountered an error.
  failed,
}

/// An immutable model representing one step in the analysis pipeline.
///
/// Each stage maps 1:1 to a backend progress callback emitted by
/// [AnalysisPipeline] and is visualized in the Processing screen.
class PipelineStage {
  /// Human-readable label for this stage.
  final String label;

  /// The icon displayed alongside this stage.
  final IconData icon;

  /// The current execution status.
  final StageStatus status;

  /// Optional timestamp when this stage started or completed.
  final DateTime? timestamp;

  const PipelineStage({
    required this.label,
    required this.icon,
    this.status = StageStatus.pending,
    this.timestamp,
  });

  PipelineStage copyWith({
    String? label,
    IconData? icon,
    StageStatus? status,
    DateTime? timestamp,
  }) {
    return PipelineStage(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
