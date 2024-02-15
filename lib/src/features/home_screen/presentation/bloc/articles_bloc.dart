import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/src/core/errors/failures.dart';
import 'package:flutter_clean_architecture/src/features/home_screen/domain/entities/artciles_params.dart';
import 'package:flutter_clean_architecture/src/features/home_screen/domain/entities/article.dart';
import 'package:flutter_clean_architecture/src/features/home_screen/domain/usecases/all_articles_usecase.dart';
import 'package:flutter_clean_architecture/src/features/home_screen/presentation/bloc/articles_event.dart';
import 'package:flutter_clean_architecture/src/features/home_screen/presentation/bloc/articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final AllArticlesUseCase allArticlesUseCase;
  List<Article> allArticlesList = [];
  ArticlesBloc({required this.allArticlesUseCase})
      : super(LoadingGetArticlesState()) {
    on<OnGettingArticlesEvent>(_onGettingArticlesEvent);
    on<OnSearchingArticlesEvents>(_onSearchingEvent);
  }

  _onGettingArticlesEvent(
      OnGettingArticlesEvent event, Emitter<ArticlesState> emittor) async {
    if (event.wihtLoading) {
      emittor(LoadingGetArticlesState());
    }

    final result =
        await allArticlesUseCase.call(ArticlesParams(period: event.period));

    result.fold((l) {
      if (l is CancelTokenFailure) {
        emittor(LoadingGetArticlesState());
      } else {
        emittor(ErrorGetArticlesState(l.errorMessage));
      }
    }, (r) {
      allArticlesList = r;
      emittor(SuccessGetArticlesState(_runFilter(event.text)));
    });
  }

  _onSearchingEvent(
      OnSearchingArticlesEvents event, Emitter<ArticlesState> emittor) async {}

  List<Article> _runFilter(String text) {
    List<Article> results = [];
    if (text.isEmpty) {
      results = List.from(allArticlesList);
    } else {
      results = allArticlesList.where((element) {
        return (element.title).toLowerCase().contains(text.toString());
      }).toList();
    }
    return results;
  }
}
