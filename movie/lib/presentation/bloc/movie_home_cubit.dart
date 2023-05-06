import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_home_state.dart';

class MovieHomeCubit extends Cubit<MovieHomeState> {

  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieHomeCubit({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(
      const MovieHomeState(
          message: "",
          nowPlayingState: RequestState.Empty,
          nowPlayingMovies: <Movie>[],
          popularMoviesState: RequestState.Empty,
          popularMovies: <Movie>[],
          topRatedMoviesState: RequestState.Empty,
          topRatedMovies: <Movie>[]
      )
  );

  Future<void> fetchNowPlayingMovies() async {
    emit(
      state.copyWith(
        nowPlayingState: RequestState.Loading
      )
    );
    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            message: failure.message,
            nowPlayingState: RequestState.Error
          )
        );
      },
      (moviesData) {
        emit(
          state.copyWith(
            nowPlayingState: RequestState.Loaded,
            nowPlayingMovies: moviesData
          )
        );
      },
    );
  }

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
