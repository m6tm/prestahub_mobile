import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/app_preferences_service.dart';

/// État immuable des préférences applicatives (thème + langue).
class AppPreferencesState {
  final AppThemeMode themeMode;
  final AppLanguage language;

  const AppPreferencesState({
    required this.themeMode,
    required this.language,
  });

  const AppPreferencesState.initial()
      : themeMode = AppThemeMode.system,
        language = AppLanguage.fr;

  AppPreferencesState copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
  }) {
    return AppPreferencesState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }
}

/// Notifier exposant les préférences globales lues/écrites depuis
/// [AppPreferencesService]. Le premier [build] hydrate l'état depuis le disque.
class AppPreferencesNotifier extends AsyncNotifier<AppPreferencesState> {
  @override
  Future<AppPreferencesState> build() async {
    final theme = await AppPreferencesService.getThemeMode();
    final language = await AppPreferencesService.getLanguage();
    return AppPreferencesState(themeMode: theme, language: language);
  }

  Future<void> updateTheme(AppThemeMode mode) async {
    final current = state.valueOrNull ?? const AppPreferencesState.initial();
    state = AsyncValue.data(current.copyWith(themeMode: mode));
    await AppPreferencesService.setThemeMode(mode);
  }

  Future<void> updateLanguage(AppLanguage language) async {
    final current = state.valueOrNull ?? const AppPreferencesState.initial();
    state = AsyncValue.data(current.copyWith(language: language));
    await AppPreferencesService.setLanguage(language);
  }
}

final appPreferencesProvider =
    AsyncNotifierProvider<AppPreferencesNotifier, AppPreferencesState>(
  () => AppPreferencesNotifier(),
);
