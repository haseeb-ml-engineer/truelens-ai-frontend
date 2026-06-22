import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the currently selected bottom navigation tab.
final navigationIndexProvider = StateProvider<int>((ref) => 0);