import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProgressNotifier extends StateNotifier<bool> {
  ProgressNotifier() : super(false);

  void start() => state = true;
  void stop() => state = false;
  bool get loading => state;
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, bool>((ref) => ProgressNotifier());
