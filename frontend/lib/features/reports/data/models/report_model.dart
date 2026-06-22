import 'package:deepshield_ai/features/analysis/data/models/scan_result_model.dart';

/// Extended report model wrapping a scan result with additional details.
class ReportModel {
  final ScanResultModel scanResult;
  final String analysisId;
  final String modelVersion;
  final Map<String, double> detailedScores;
  final List<TimelineEntry> timeline;
  final String? heatmapUrl;

  const ReportModel({
    required this.scanResult,
    required this.analysisId,
    required this.modelVersion,
    this.detailedScores = const {},
    this.timeline = const [],
    this.heatmapUrl,
  });

  /// Creates a mock report for development.
  factory ReportModel.mock() {
    final scan = ScanResultModel.mockList().first;
    return ReportModel(
      scanResult: scan,
      analysisId: 'RPT-2024-001',
      modelVersion: 'TrueLens v2.1.0',
      detailedScores: {
        'Face Manipulation': 0.94,
        'GAN Artifacts': 0.89,
        'Texture Analysis': 0.91,
        'Metadata Integrity': 0.72,
        'Noise Pattern': 0.85,
      },
      timeline: [
        TimelineEntry(
          label: 'File uploaded',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isCompleted: true,
        ),
        TimelineEntry(
          label: 'Face detection completed',
          timestamp: DateTime.now().subtract(const Duration(minutes: 4, seconds: 45)),
          isCompleted: true,
        ),
        TimelineEntry(
          label: 'Artifact analysis completed',
          timestamp: DateTime.now().subtract(const Duration(minutes: 4, seconds: 20)),
          isCompleted: true,
        ),
        TimelineEntry(
          label: 'AI model inference completed',
          timestamp: DateTime.now().subtract(const Duration(minutes: 3, seconds: 50)),
          isCompleted: true,
        ),
        TimelineEntry(
          label: 'Report generated',
          timestamp: DateTime.now().subtract(const Duration(minutes: 3, seconds: 30)),
          isCompleted: true,
        ),
      ],
    );
  }
}

/// A single entry in the analysis timeline.
class TimelineEntry {
  final String label;
  final DateTime timestamp;
  final bool isCompleted;

  const TimelineEntry({
    required this.label,
    required this.timestamp,
    this.isCompleted = false,
  });
}