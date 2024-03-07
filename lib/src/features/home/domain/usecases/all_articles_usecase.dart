import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/src/core/errors/failures.dart';
import 'package:flutter_clean_architecture/src/core/utils/typedef/typedef.dart';
import 'package:flutter_clean_architecture/src/core/utils/usecases/usecase.dart';
import 'package:flutter_clean_architecture/src/features/home/home.dart';

class AllArticlesUseCase
    extends UseCaseWithParams<List<Article>, ArticlesParams> {
  final AbstractArticleRepository repository;
  AllArticlesUseCase(this.repository);
  @override
  ResultFuture<List<Article>> call(ArticlesParams params) async {
    final Either<Failure, List<Article>> results =
        await repository.getArticles(params);
    return results.fold((Failure l) {
      return Left<Failure, List<Article>>(l);
    }, (List<Article> r) async {
      return Right<Failure, List<Article>>(r);
    });
  }
}
