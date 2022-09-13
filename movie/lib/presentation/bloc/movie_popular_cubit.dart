import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/presentation/bloc/movie_popular_state.dart';

class MoviePopularCubit extends Cubit<MoviePopularState> {

  final GetPopularMovies getPopularMovies;

  MoviePopularCubit({
    required this.getPopularMovies,
  }) : super(
      MoviePopularState(
          message: "",
          popularMoviesState: RequestState.Empty,
          popularMovies: <Movie>[],
      )
  );

  Future<void> fetchPopularMovies() async {
    emit(
        state.copyWith(
            popularMoviesState: RequestState.Loading
        )
    );
    final result = await getPopularMovies.execute();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            message: failure.message,
            popularMoviesState: RequestState.Error
          )
        );
      },
      (moviesData) {
        emit(
          state.copyWith(
            popularMoviesState: RequestState.Loaded,
            popularMovies: moviesData
          )
        );
      },
    );
  }
}
