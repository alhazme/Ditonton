import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_top_rated_cubit_test.mocks.dart';
import 'package:movie/presentation/bloc/movie_top_rated_cubit.dart';
import 'package:movie/presentation/bloc/movie_top_rated_state.dart';

@GenerateMocks([
  GetTopRatedMovies,
])
void main() {
  late MovieTopRatedCubit movieTopRatedCubit;
  late MovieTopRatedState movieTopRatedState;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieTopRatedCubit = MovieTopRatedCubit(
        getTopRatedMovies: mockGetTopRatedMovies
    );
    movieTopRatedState = const MovieTopRatedState(
      message: "",
      topRatedMoviesState: RequestState.Empty,
      topRatedMovies: <Movie>[],
    );
  });

  test('Initial state should be equal to default MovieTopRatedState', () {
    expect(movieTopRatedCubit.state, movieTopRatedState);
  });

  blocTest<MovieTopRatedCubit, MovieTopRatedState>(
    'Should emit error when fetchTopRatedMovies is error',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('failed fetchTopRatedMovies')));
      return movieTopRatedCubit;
    },
    act: (cubit) => cubit.fetchTopRatedMovies(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MovieTopRatedState(
        message: '',
        topRatedMoviesState: RequestState.Loading,
        topRatedMovies: <Movie>[],
      ),
      const MovieTopRatedState(
        message: 'failed fetchTopRatedMovies',
        topRatedMoviesState: RequestState.Error,
        topRatedMovies: <Movie>[],
      ),
    ],
  );

  blocTest<MovieTopRatedCubit, MovieTopRatedState>(
    'Should emit success when fetchTopRatedMovies is success',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(mockedMovieList));
      return movieTopRatedCubit;
    },
    act: (cubit) => cubit.fetchTopRatedMovies(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MovieTopRatedState(
        message: '',
        topRatedMoviesState: RequestState.Loading,
        topRatedMovies: <Movie>[],
      ),
      MovieTopRatedState(
        message: '',
        topRatedMoviesState: RequestState.Loaded,
        topRatedMovies: mockedMovieList,
      ),
    ],
  );
}