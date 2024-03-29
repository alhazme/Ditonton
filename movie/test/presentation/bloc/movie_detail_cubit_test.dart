import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/save_movie_watchlist.dart';
import 'package:movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_detail_state.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveMovieWatchlist,
  RemoveWatchlist,
])
void main() {

  late MovieDetailCubit movieDetailCubit;
  late MovieDetailState movieDetailState;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveMovieWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  const tId = 1;
  
  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveMovieWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieDetailCubit = MovieDetailCubit(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveMovieWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist
    );
    movieDetailState = MovieDetailState(
        message: "",
        movieDetailState: RequestState.Empty,
        movieDetail: null,
        movieRecommendationsState: RequestState.Empty,
        movieRecommendations: const <Movie>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ""
    );
  });

	group('MovieDetailCubitTest', () {

		test('Initial state should be equal to default MovieDetailState', () {
			expect(movieDetailCubit.state, movieDetailState);
		});

		blocTest<MovieDetailCubit, MovieDetailState>(
			'Should emit error when getMovieDetail is error',
			build: () {
				when(mockGetMovieDetail.execute(tId))
						.thenAnswer((_) async => const Left(ServerFailure('failed fetchMovieDetail')));
				when(mockGetMovieRecommendations.execute(tId))
						.thenAnswer((_) async => const Left(ServerFailure('failed fetchMovieRecommendations')));
				when(mockGetWatchlistStatus.execute(tId))
						.thenAnswer((_) async => false);
				return movieDetailCubit;
			},
			act: (cubit) => cubit.fetchMovieDetail(tId),
			wait: const Duration(milliseconds: 300),
			expect: () => [
				MovieDetailState(
						message: '',
						movieDetailState: RequestState.Loading,
						movieDetail: null,
						movieRecommendationsState: RequestState.Empty,
						movieRecommendations: const <Movie>[],
						isAddedtoWatchlist: false,
						watchlistMessage: ''
				),
				MovieDetailState(
						message: 'failed fetchMovieDetail',
						movieDetailState: RequestState.Error,
						movieDetail: null,
						movieRecommendationsState: RequestState.Empty,
						movieRecommendations: const <Movie>[],
						isAddedtoWatchlist: false,
						watchlistMessage: ''
				),
			],
		);

		blocTest<MovieDetailCubit, MovieDetailState>(
			'Should emit error when getMovieDetail is success but getMovieRecommendations is error',
			build: () {
				when(mockGetMovieDetail.execute(tId))
						.thenAnswer((_) async => const Right(mockedMovieDetail));
				when(mockGetMovieRecommendations.execute(tId))
						.thenAnswer((_) async => const Left(ServerFailure('failed fetchMovieRecommendations')));
				when(mockGetWatchlistStatus.execute(tId))
						.thenAnswer((_) async => false);
				return movieDetailCubit;
			},
			act: (cubit) => cubit.fetchMovieDetail(tId),
			wait: const Duration(milliseconds: 300),
			expect: () => [
				MovieDetailState(
					message: '',
					movieDetailState: RequestState.Loading,
					movieDetail: null,
					movieRecommendationsState: RequestState.Empty,
					movieRecommendations: const <Movie>[],
					isAddedtoWatchlist: false,
						watchlistMessage: ''
				),
				MovieDetailState(
					message: '',
					movieDetailState: RequestState.Loaded,
					movieDetail: mockedMovieDetail,
					movieRecommendationsState: RequestState.Empty,
					movieRecommendations: const <Movie>[],
					isAddedtoWatchlist: false,
						watchlistMessage: ''
				),
				MovieDetailState(
					message: 'failed fetchMovieRecommendations',
					movieDetailState: RequestState.Loaded,
					movieDetail: mockedMovieDetail,
					movieRecommendationsState: RequestState.Error,
					movieRecommendations: const <Movie>[],
					isAddedtoWatchlist: false,
						watchlistMessage: ''
				)
			],
		);

		blocTest<MovieDetailCubit, MovieDetailState>(
			'Should emit error when getMovieDetail is success but getMovieRecommendations is success too',
			build: () {
				when(mockGetMovieDetail.execute(tId))
						.thenAnswer((_) async => const Right(mockedMovieDetail));
				when(mockGetMovieRecommendations.execute(tId))
						.thenAnswer((_) async => Right(mockedMovieList));
				when(mockGetWatchlistStatus.execute(tId))
						.thenAnswer((_) async => false);
				return movieDetailCubit;
			},
			act: (cubit) => cubit.fetchMovieDetail(tId),
			wait: const Duration(milliseconds: 300),
			expect: () => [
				MovieDetailState(
					message: '',
					movieDetailState: RequestState.Loading,
					movieDetail: null,
					movieRecommendationsState: RequestState.Empty,
					movieRecommendations: const <Movie>[],
					isAddedtoWatchlist: false,
					watchlistMessage: ''
				),
				MovieDetailState(
					message: '',
					movieDetailState: RequestState.Loaded,
					movieDetail: mockedMovieDetail,
					movieRecommendationsState: RequestState.Empty,
					movieRecommendations: const <Movie>[],
					isAddedtoWatchlist: false,
					watchlistMessage: ''
				),
				MovieDetailState(
					message: '',
					movieDetailState: RequestState.Loaded,
					movieDetail: mockedMovieDetail,
					movieRecommendationsState: RequestState.Loaded,
					movieRecommendations: mockedMovieList,
					isAddedtoWatchlist: false,
					watchlistMessage: ''
				)
			],
		);

		blocTest<MovieDetailCubit, MovieDetailState>(
			'Should emit error when addWatchlist is error',
			build: () {
				when(mockSaveWatchlist.execute(mockedMovieDetail))
						.thenAnswer((_) async => const Left(DatabaseFailure('failed saveMovieWatchlist')));
				return movieDetailCubit;
			},
			act: (cubit) => cubit.addWatchlist(mockedMovieDetail),
			wait: const Duration(milliseconds: 300),
			expect: () => [
				MovieDetailState(
						message: '',
						movieDetailState: RequestState.Empty,
						movieDetail: null,
						movieRecommendationsState: RequestState.Empty,
						movieRecommendations: const <Movie>[],
						isAddedtoWatchlist: false,
						watchlistMessage: 'failed saveMovieWatchlist'
				),
			],
		);

		blocTest<MovieDetailCubit, MovieDetailState>(
			'Should emit success when addWatchlist is success',
			build: () {
				when(mockSaveWatchlist.execute(mockedMovieDetail))
						.thenAnswer((_) async => const Right(MovieDetailCubit.watchlistAddSuccessMessage));
				return movieDetailCubit;
			},
			act: (cubit) => cubit.addWatchlist(mockedMovieDetail),
			wait: const Duration(milliseconds: 300),
			expect: () => [
				MovieDetailState(
						isAddedtoWatchlist: true,
						watchlistMessage: MovieDetailCubit.watchlistAddSuccessMessage
				),
			],
		);

		blocTest<MovieDetailCubit, MovieDetailState>(
			'Should emit error when removeFromWatchlist is error',
			build: () {
				when(mockRemoveWatchlist.execute(tId))
						.thenAnswer((_) async => const Left(DatabaseFailure('failed removeFromWatchlist')));
				return movieDetailCubit;
			},
			act: (cubit) => cubit.removeFromWatchlist(tId),
			wait: const Duration(milliseconds: 300),
			expect: () => [
				MovieDetailState(
						isAddedtoWatchlist: true,
						watchlistMessage: 'failed removeFromWatchlist'
				),
			],
		);

		blocTest<MovieDetailCubit, MovieDetailState>(
			'Should emit success when removeFromWatchlist is success',
			build: () {
				when(mockRemoveWatchlist.execute(tId))
						.thenAnswer((_) async => const Right(MovieDetailCubit.watchlistRemoveSuccessMessage));
				return movieDetailCubit;
			},
			act: (cubit) => cubit.removeFromWatchlist(tId),
			wait: const Duration(milliseconds: 300),
			expect: () => [
				MovieDetailState(
						isAddedtoWatchlist: false,
						watchlistMessage: MovieDetailCubit.watchlistRemoveSuccessMessage
				),
			],
		);

		blocTest<MovieDetailCubit, MovieDetailState>(
			'Should update isAddedToWatchlist', 
			build: () {
				when(mockGetWatchlistStatus.execute(tId))
					.thenAnswer((_) async => true);
				return movieDetailCubit;
			},
			act: (cubit) => cubit.loadWatchlistStatus(tId),
			wait: const Duration(milliseconds: 300),
			expect: () => [
				MovieDetailState(
					isAddedtoWatchlist: true,
					watchlistMessage: '',
				)
			],
		);
	});
}