import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/src/core/core_exports.dart';
import 'package:flutter_clean_architecture/src/shared/shared_exports.dart';

void initAppInjections() {
  // Register AppSharedPrefs as a singleton
  getIt.registerLazySingleton<AppSharedPrefs>(() => AppSharedPrefs(getIt()));

  // Register ThemeSwitchBloc as a singleton
  getIt.registerFactory<ThemeSwitchBloc>(() => ThemeSwitchBloc());

  // Register NetworkCubit as a singleton
  if (!kIsWeb) getIt.registerLazySingleton<NetworkCubit>(() => NetworkCubit());
}
