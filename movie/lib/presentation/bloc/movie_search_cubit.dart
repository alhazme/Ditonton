import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/movie_search_state.dart';

class MovieSearchCubit extends Cubit<MovieSearchState> {

  final SearchMovies searchMovies;

  MovieSearchCubit({
    required this.searchMovies,
  }) : super(
      const MovieSearchState(
        message: "",
        state: RequestState.Empty,
        searchResult: <Movie>[],
      )
  );

  Future<void> fetchMovieSearch(String query) async {
    emit(
        state.copyWith(
          message: "",
          state: RequestState.Loading,
          searchResult: <Movie>[],
        )
    );
    final result = await searchMovies.execute(query);
    result.fold(
      (failure) {
        emit(
            state.copyWith(
                message: failure.message,
                state: RequestState.Error
            )
        );
      },
      (moviesData) {
        emit(
            state.copyWith(
                state: RequestState.Loaded,
                searchResult: moviesData
            )
        );
      },
    );
  }

}