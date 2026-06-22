import 'package:deepshield_ai/features/reports/domain/repositories/report_repository.dart';
import 'package:deepshield_ai/features/reports/data/models/report_model.dart';

/// Mock report service.
///
/// Handles report generation and retrieval.
/// Replace with FastAPI + PDF generation later.
class MockReportRepository implements ReportRepository {
  /// Retrieves a report by scan ID.
  @override
  Future<ReportModel> getReport(String scanId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ReportModel.mock();
  }

  /// Simulates downloading a report as PDF.
  @override
  Future<String> downloadReportPdf(String reportId) async {
    await Future.delayed(const Duration(seconds: 1));
    // Returns a mock file path
    return '/downloads/truelens_report_$reportId.pdf';
  }

  /// Simulates sharing a report.
  @override
  Future<String> shareReport(String reportId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Returns a mock share URL
    return 'https://truelens.ai/reports/$reportId';
  }
}