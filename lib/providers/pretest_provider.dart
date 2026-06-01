import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';

class PretestStatusNotifier extends StateNotifier<bool> {
  final SharedPreferences prefs;

  PretestStatusNotifier(this.prefs) : super(prefs.getBool('pretest_completed') ?? false);

  void setCompleted() {
    state = true;
    prefs.setBool('pretest_completed', true);
  }
}

final pretestStatusProvider = StateNotifierProvider<PretestStatusNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PretestStatusNotifier(prefs);
});
