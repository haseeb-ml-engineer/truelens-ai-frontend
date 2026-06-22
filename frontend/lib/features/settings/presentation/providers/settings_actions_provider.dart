import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/result.dart';
import '../../../analysis/presentation/providers/analysis_provider.dart';

/// Clears all persisted analysis history via the analysis repository.
final clearAnalysisHistoryProvider = Provider<Future<Result<bool>> Function()>(
  (ref) {
    return () => ref.read(analysisServiceProvider).clearHistory();
  },
);
