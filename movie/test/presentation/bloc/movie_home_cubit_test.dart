import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_home_cubit.dart';
import 'package:movie/presentation/bloc/movie_home_state.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_home_cubit_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
])
void main() {
  late MovieHomeCubit movieHomeCubit;
  late MovieHomeState movieHomeState;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  const tId = 1;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieHomeCubit = MovieHomeCubit(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies
    );
    movieHomeState = const MovieHomeState(
      message: "",
      nowPlayingState: RequestState.Empty,
      nowPlayingMovies: <Movie>[],
      popularMoviesState: RequestState.Empty,
      popularMovies: <Movie>[],
      topRatedMoviesState: RequestState.Empty,
      topRatedMovies: <Movie>[],
    );
  });

  test('Initial state should be equal to default MovieHomeState', () {
    expect(movieHomeCubit.state, movieHomeState);
  });

  blocTest<MovieHomeCubit, MovieHomeState>(
    'Should emit error when fetchNowPlayingMovies is error',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('failed fetchNowPlayingMovies')));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchNowPlayingMovies(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Loading,
        nowPlayingMovies: <Movie>[],
        popularMoviesState: RequestState.Empty,
        popularMovies: <Movie>[],
        topRatedMoviesState: RequestState.Empty,
        topRatedMovies: <Movie>[],
      ),
      const MovieHomeState(
        message: 'failed fetchNowPlayingMovies',
        nowPlayingState: RequestState.Error,
        nowPlayingMovies: <Movie>[],
        popularMoviesState: RequestState.Empty,
        popularMovies: <Movie>[],
        topRatedMoviesState: RequestState.Empty,
        topRatedMovies: <Movie>[],
      ),
    ],
  );

  blocTest<MovieHomeCubit, MovieHomeState>(
    'Should emit success when fetchNowPlayingMovies is success',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(mockedMovieList));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchNowPlayingMovies(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Loading,
        nowPlayingMovies: <Movie>[],
        popularMoviesState: RequestState.Empty,
        popularMovies: <Movie>[],
        topRatedMoviesState: RequestState.Empty,
        topRatedMovies: <Movie>[],
      ),
      MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Loaded,
        nowPlayingMovies: mockedMovieList,
        popularMoviesState: RequestState.Empty,
        popularMovies: const <Movie>[],
        topRatedMoviesState: RequestState.Empty,
        topRatedMovies: const <Movie>[],
      ),
    ],
  );

  blocTest<MovieHomeCubit, MovieHomeState>(
    'Should emit error when fetchPopularMovies is error',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('failed fetchPopularMovies')));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchPopularMovies(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Empty,
        nowPlayingMovies: <Movie>[],
        popularMoviesState: RequestState.Loading,
        popularMovies: <Movie>[],
        topRatedMoviesState: RequestState.Empty,
        topRatedMovies: <Movie>[],
      ),
      const MovieHomeState(
        message: 'failed fetchPopularMovies',
        nowPlayingState: RequestState.Empty,
        nowPlayingMovies: <Movie>[],
        popularMoviesState: RequestState.Error,
        popularMovies: <Movie>[],
        topRatedMoviesState: RequestState.Empty,
        topRatedMovies: <Movie>[],
      ),
    ],
  );

  blocTest<MovieHomeCubit, MovieHomeState>(
    'Should emit success when fetchPopularMovies is success',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(mockedMovieList));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchPopularMovies(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Empty,
        nowPlayingMovies: <Movie>[],
        popularMoviesState: RequestState.Loading,
        popularMovies: <Movie>[],
        topRatedMoviesState: RequestState.Empty,
        topRatedMovies: <Movie>[],
      ),
      MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Empty,
        nowPlayingMovies: const <Movie>[],
        popularMoviesState: RequestState.Loaded,
        popularMovies: mockedMovieList,
        topRatedMoviesState: RequestState.Empty,
        topRatedMovies: const <Movie>[],
      ),
    ],
  );

  blocTest<MovieHomeCubit, MovieHomeState>(
    'Should emit error when fetchTopRatedMovies is error',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('failed fetchTopRatedMovies')));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchTopRatedMovies(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Empty,
        nowPlayingMovies: <Movie>[],
        popularMoviesState: RequestState.Empty,
        popularMovies: <Movie>[],
        topRatedMoviesState: RequestState.Loading,
        topRatedMovies: <Movie>[],
      ),
      const MovieHomeState(
        message: 'failed fetchTopRatedMovies',
        nowPlayingState: RequestState.Empty,
        nowPlayingMovies: <Movie>[],
        popularMoviesState: RequestState.Empty,
        popularMovies: <Movie>[],
        topRatedMoviesState: RequestState.Error,
        topRatedMovies: <Movie>[],
      ),
    ],
  );

  blocTest<MovieHomeCubit, MovieHomeState>(
    'Should emit success when fetchTopRatedMovies is success',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(mockedMovieList));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchTopRatedMovies(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Empty,
        nowPlayingMovies: <Movie>[],
        popularMoviesState: RequestState.Empty,
        popularMovies: <Movie>[],
        topRatedMoviesState: RequestState.Loading,
        topRatedMovies: <Movie>[],
      ),
      MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Empty,
        nowPlayingMovies: const <Movie>[],
        popularMoviesState: RequestState.Empty,
        popularMovies: const <Movie>[],
        topRatedMoviesState: RequestState.Loaded,
        topRatedMovies: mockedMovieList,
      ),
    ],
  );
}