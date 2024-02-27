import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/src/core/errors/expections.dart';
import 'package:flutter_clean_architecture/src/core/errors/failures.dart';
import 'package:flutter_clean_architecture/src/core/models/api_response.dart';
import 'package:flutter_clean_architecture/src/core/utils/typedef/typedef.dart';
import 'package:flutter_clean_architecture/src/features/home/data/data_sources/remote/articles_impl_api.dart';
import 'package:flutter_clean_architecture/src/features/home/data/dto/article_dto.dart';
import 'package:flutter_clean_architecture/src/features/home/domain/entities/artciles_params.dart';
import 'package:flutter_clean_architecture/src/features/home/domain/repositories/abstract_articles_repository.dart';

class ArticlesRepoImpl extends AbstractArticleRepository {
  final ArticlesImplApi articlesImplApi;
  ArticlesRepoImpl(this.articlesImplApi);
  @override
  ResultFuture<List<ArticleDto>> getArticles(
      ArticlesParams articlesParams) async {
    try {
      final ApiResponse<List<ArticleDto>> results =
          await articlesImplApi.getArticles(articlesParams);
      return Right<Failure, List<ArticleDto>>(results.results);
    } on ServerException catch (e) {
      return Left<Failure, List<ArticleDto>>(
          ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left<Failure, List<ArticleDto>>(
          ServerFailure(e.message, e.statusCode));
    }
  }
}
