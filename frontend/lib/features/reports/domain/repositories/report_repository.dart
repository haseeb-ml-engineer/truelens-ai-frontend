import 'package:deepshield_ai/features/reports/data/models/report_model.dart';

abstract class ReportRepository {
  Future<ReportModel> getReport(String scanId);
  Future<String> downloadReportPdf(String reportId);
  Future<String> shareReport(String reportId);
}
