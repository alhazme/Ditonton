import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/presentation/bloc/movie_popular_cubit.dart';
import 'package:movie/presentation/bloc/movie_popular_state.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_popular_cubit_test.mocks.dart';

@GenerateMocks([
  GetPopularMovies,
])
void main() {
  late MoviePopularCubit moviePopularCubit;
  late MoviePopularState moviePopularState;
  late MockGetPopularMovies mockGetPopularMovies;

  const tId = 1;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    moviePopularCubit = MoviePopularCubit(
        getPopularMovies: mockGetPopularMovies
    );
    moviePopularState = const MoviePopularState(
      message: "",
      popularMoviesState: RequestState.Empty,
      popularMovies: <Movie>[],
    );
  });

  test('Initial state should be equal to default MoviePopularState', () {
    expect(moviePopularCubit.state, moviePopularState);
  });

  blocTest<MoviePopularCubit, MoviePopularState>(
    'Should emit error when fetchPopularMovies is error',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('failed fetchPopularMovies')));
      return moviePopularCubit;
    },
    act: (cubit) => cubit.fetchPopularMovies(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MoviePopularState(
        message: '',
        popularMoviesState: RequestState.Loading,
        popularMovies: <Movie>[],
      ),
      const MoviePopularState(
        message: 'failed fetchPopularMovies',
        popularMoviesState: RequestState.Error,
        popularMovies: <Movie>[],
      ),
    ],
  );

  blocTest<MoviePopularCubit, MoviePopularState>(
    'Should emit success when fetchPopularMovies is success',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(mockedMovieList));
      return moviePopularCubit;
    },
    act: (cubit) => cubit.fetchPopularMovies(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MoviePopularState(
        message: '',
        popularMoviesState: RequestState.Loading,
        popularMovies: <Movie>[],
      ),
      MoviePopularState(
        message: '',
        popularMoviesState: RequestState.Loaded,
        popularMovies: mockedMovieList,
      ),
    ],
  );
}