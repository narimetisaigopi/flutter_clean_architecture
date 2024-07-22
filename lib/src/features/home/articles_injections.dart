import 'package:flutter_clean_architecture/src/core/injections.dart';
import 'package:flutter_clean_architecture/src/features/home/home_exports.dart';

void initArticleInjections() {
  getIt.registerLazySingleton<ArticlesImplApi>(() => ArticlesImplApi(getIt()));
  getIt.registerLazySingleton<AbstractArticleRepository>(
    () => ArticlesRepoImpl(getIt()),
  );
  getIt.registerLazySingleton<AllArticlesUseCase>(
    () => AllArticlesUseCase(getIt()),
  );
}
