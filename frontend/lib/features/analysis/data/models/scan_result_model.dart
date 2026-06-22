/// Represents the risk level of an analysis result.
enum RiskLevel { low, medium, high }

/// Represents the type of media scanned.
enum MediaType { image, video }

/// Data model for a scan/analysis result.
class ScanResultModel {
  final String id;
  final String fileName;
  final MediaType mediaType;
  final DateTime scannedAt;
  final double aiProbability;
  final double confidenceScore;
  final RiskLevel riskLevel;
  final Duration processingTime;
  final String? thumbnailUrl;
  final List<String> suspiciousIndicators;
  final String recommendation;
  final bool isCompleted;

  const ScanResultModel({
    required this.id,
    required this.fileName,
    required this.mediaType,
    required this.scannedAt,
    required this.aiProbability,
    required this.confidenceScore,
    required this.riskLevel,
    required this.processingTime,
    this.thumbnailUrl,
    this.suspiciousIndicators = const [],
    this.recommendation = '',
    this.isCompleted = true,
  });

  /// Returns a human-readable risk label.
  String get riskLabel {
    switch (riskLevel) {
      case RiskLevel.low:
        return 'Low';
      case RiskLevel.medium:
        return 'Medium';
      case RiskLevel.high:
        return 'High';
    }
  }

  /// Returns the media type label.
  String get mediaTypeLabel {
    switch (mediaType) {
      case MediaType.image:
        return 'Image';
      case MediaType.video:
        return 'Video';
    }
  }

  /// Creates a list of mock scan results for development.
  static List<ScanResultModel> mockList() {
    return [
      ScanResultModel(
        id: 'scan_001',
        fileName: 'profile_photo.jpg',
        mediaType: MediaType.image,
        scannedAt: DateTime.now().subtract(const Duration(hours: 2)),
        aiProbability: 0.92,
        confidenceScore: 0.95,
        riskLevel: RiskLevel.high,
        processingTime: const Duration(seconds: 4, milliseconds: 230),
        suspiciousIndicators: [
          'Inconsistent lighting on facial features',
          'Unnatural skin texture patterns detected',
          'Facial boundary artifacts present',
          'Asymmetric ear geometry',
        ],
        recommendation:
            'This image shows strong indicators of AI generation. '
            'We recommend verifying the source and not using it for identity verification.',
      ),
      ScanResultModel(
        id: 'scan_002',
        fileName: 'meeting_recording.mp4',
        mediaType: MediaType.video,
        scannedAt: DateTime.now().subtract(const Duration(hours: 5)),
        aiProbability: 0.15,
        confidenceScore: 0.88,
        riskLevel: RiskLevel.low,
        processingTime: const Duration(seconds: 12, milliseconds: 800),
        suspiciousIndicators: [
          'Minor compression artifacts (normal)',
        ],
        recommendation:
            'This video appears to be authentic with no significant signs of AI manipulation.',
      ),
      ScanResultModel(
        id: 'scan_003',
        fileName: 'news_thumbnail.png',
        mediaType: MediaType.image,
        scannedAt: DateTime.now().subtract(const Duration(days: 1)),
        aiProbability: 0.67,
        confidenceScore: 0.78,
        riskLevel: RiskLevel.medium,
        processingTime: const Duration(seconds: 3, milliseconds: 150),
        suspiciousIndicators: [
          'Background inconsistencies detected',
          'Unusual shadow patterns',
        ],
        recommendation:
            'This image shows moderate signs of possible manipulation. '
            'Further investigation is recommended.',
      ),
      ScanResultModel(
        id: 'scan_004',
        fileName: 'vacation_photo.jpg',
        mediaType: MediaType.image,
        scannedAt: DateTime.now().subtract(const Duration(days: 2)),
        aiProbability: 0.05,
        confidenceScore: 0.97,
        riskLevel: RiskLevel.low,
        processingTime: const Duration(seconds: 2, milliseconds: 800),
        suspiciousIndicators: [],
        recommendation: 'This image appears to be authentic.',
      ),
      ScanResultModel(
        id: 'scan_005',
        fileName: 'interview_clip.mp4',
        mediaType: MediaType.video,
        scannedAt: DateTime.now().subtract(const Duration(days: 3)),
        aiProbability: 0.85,
        confidenceScore: 0.91,
        riskLevel: RiskLevel.high,
        processingTime: const Duration(seconds: 18, milliseconds: 400),
        suspiciousIndicators: [
          'Lip-sync anomalies detected',
          'Frame-level temporal inconsistencies',
          'Facial blending artifacts',
        ],
        recommendation:
            'This video shows strong indicators of deepfake manipulation, '
            'particularly around the face and lip movements.',
      ),
    ];
  }
}