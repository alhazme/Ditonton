import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_top_rated_state.dart';

class MovieTopRatedCubit extends Cubit<MovieTopRatedState> {

  final GetTopRatedMovies getTopRatedMovies;

  MovieTopRatedCubit({
    required this.getTopRatedMovies,
  }) : super(
      const MovieTopRatedState(
        message: "",
        topRatedMoviesState: RequestState.Empty,
        topRatedMovies: <Movie>[],
      )
  );

  Future<void> fetchTopRatedMovies() async {
    emit(
        state.copyWith(
            topRatedMoviesState: RequestState.Loading
        )
    );
    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) {
        emit(
            state.copyWith(
                message: failure.message,
                topRatedMoviesState: RequestState.Error
            )
        );
      },
      (moviesData) {
        emit(
            state.copyWith(
                topRatedMoviesState: RequestState.Loaded,
                topRatedMovies: moviesData
            )
        );
      },
    );
  }
}
