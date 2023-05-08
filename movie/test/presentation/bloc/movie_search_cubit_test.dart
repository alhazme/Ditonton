import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/movie_search_cubit.dart';
import 'package:movie/presentation/bloc/movie_search_state.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_search_cubit_test.mocks.dart';

@GenerateMocks([
  SearchMovies,
])
void main() {
  late MovieSearchCubit movieSearchCubit;
  late MovieSearchState movieSearchState;
  late MockSearchMovies mockSearchMovies;

  const tId = 1;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchCubit = MovieSearchCubit(
        searchMovies: mockSearchMovies
    );
    movieSearchState = const MovieSearchState(
      message: "",
      state: RequestState.Empty,
      searchResult: <Movie>[],
    );
  });

  test('Initial state should be equal to default MovieSearchState', () {
    expect(movieSearchCubit.state, movieSearchState);
  });

  blocTest<MovieSearchCubit, MovieSearchState>(
    'Should emit error when fetchMovieSearch is error',
    build: () {
      when(mockSearchMovies.execute('dragonball'))
          .thenAnswer((_) async => const Left(ServerFailure('failed fetchMovieSearch')));
      return movieSearchCubit;
    },
    act: (cubit) => cubit.fetchMovieSearch('dragonball'),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MovieSearchState(
        message: '',
        state: RequestState.Loading,
        searchResult: <Movie>[],
      ),
      const MovieSearchState(
        message: 'failed fetchMovieSearch',
        state: RequestState.Error,
        searchResult: <Movie>[],
      ),
    ],
  );

  blocTest<MovieSearchCubit, MovieSearchState>(
    'Should emit success when fetchMovieSearch is success',
    build: () {
      when(mockSearchMovies.execute('dragonball'))
          .thenAnswer((_) async => Right(mockedMovieList));
      return movieSearchCubit;
    },
    act: (cubit) => cubit.fetchMovieSearch('dragonball'),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const MovieSearchState(
        message: '',
        state: RequestState.Loading,
        searchResult: <Movie>[],
      ),
      MovieSearchState(
        message: '',
        state: RequestState.Loaded,
        searchResult: mockedMovieList,
      ),
    ],
  );
}