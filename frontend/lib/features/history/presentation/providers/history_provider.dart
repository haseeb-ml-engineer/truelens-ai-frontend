import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepshield_ai/features/analysis/data/models/scan_result_model.dart';
import 'package:deepshield_ai/features/history/data/repositories/mock_history_repository.dart';

/// State for the history screen with search and filter.
class HistoryState {
  final List<ScanResultModel> scans;
  final String searchQuery;
  final MediaType? filterType;
  final bool isLoading;

  const HistoryState({
    this.scans = const [],
    this.searchQuery = '',
    this.filterType,
    this.isLoading = false,
  });

  HistoryState copyWith({
    List<ScanResultModel>? scans,
    String? searchQuery,
    MediaType? filterType,
    bool? isLoading,
    bool clearFilter = false,
  }) {
    return HistoryState(
      scans: scans ?? this.scans,
      searchQuery: searchQuery ?? this.searchQuery,
      filterType: clearFilter ? null : (filterType ?? this.filterType),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Manages history screen state with search and filtering.
class HistoryNotifier extends StateNotifier<HistoryState> {
  final MockHistoryRepository _service;

  HistoryNotifier(this._service) : super(const HistoryState()) {
    loadHistory();
  }

  /// Load all scan history.
  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true);
    final scans = await _service.getScanHistory();
    state = state.copyWith(scans: scans, isLoading: false);
  }

  /// Search scans by query.
  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query, isLoading: true);
    final scans = await _service.searchScans(query);
    state = state.copyWith(scans: scans, isLoading: false);
  }

  /// Filter scans by media type.
  Future<void> filterByType(MediaType? type) async {
    state = state.copyWith(
      filterType: type,
      clearFilter: type == null,
      isLoading: true,
    );
    final scans = await _service.filterByType(type);
    state = state.copyWith(scans: scans, isLoading: false);
  }
}

/// Provider for history state.
final historyProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier(MockHistoryRepository());
});