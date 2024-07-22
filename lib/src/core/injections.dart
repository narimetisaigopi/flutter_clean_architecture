import 'package:flutter_clean_architecture/src/core/core_exports.dart';
import 'package:flutter_clean_architecture/src/features/auth/auth_exports.dart';
import 'package:flutter_clean_architecture/src/features/home/home_exports.dart';
import 'package:flutter_clean_architecture/src/shared/shared_exports.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> initInjections() async {
  await initDioInjections();
  await initRoutingInjections();
  initAppInjections();
  initArticleInjections();
  initAuthInjections();
  await initSharedPrefsInjections();
}

Future<void> initSharedPrefsInjections() async {
  getIt.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });
  await getIt.isReady<SharedPreferences>();
}

Future<void> initDioInjections() async {
  initRootLogger();
  DioNetwork.initDio();
  getIt.registerSingleton<DioOperations>(DioOperations(DioNetwork.appAPI));
}

Future<void> initRoutingInjections() async {
  getIt.registerLazySingleton<AppRoutingAbstract>(() => AppRouting());
}
