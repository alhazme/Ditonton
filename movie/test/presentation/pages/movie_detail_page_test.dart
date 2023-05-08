import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:movie/presentation/bloc/movie_detail_state.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'dart:ui' as ui;
import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../mocked/mock_navigator_observer.dart';

class MockedMovieDetailCubit extends MockCubit<MovieDetailState> implements MovieDetailCubit {}

void main() {
	late MovieDetailCubit movieDetailCubit;
	late MockNavigatorObserver mockObserver;
	
	setUpAll(() {
		registerFallbackValue(FakeRoute());
	});

	setUp(() {
		movieDetailCubit = MockedMovieDetailCubit();
		mockObserver = MockNavigatorObserver();
	});

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailCubit>(
      create: (_) => movieDetailCubit,
      child: MediaQuery(
        data: MediaQueryData.fromWindow(ui.window),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
						home: body,
						navigatorObservers: [mockObserver],
					),
        ),
      ),
    );
	}

	group('MovieDetailPageTest', () {
		testWidgets('show CircularProgressIndicator when movies still loading from server', (WidgetTester tester) async {

			// Arrange
			const movieId = 1;
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => Left(ServerFailure('failed fetchMovieDetail')));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => Left(ServerFailure('failed loadWatchlistStatus')));
			final mockedState = MovieDetailState(
					message: '',
					movieDetailState: RequestState.Loading,
					movieDetail: mockedMovieDetail,
					movieRecommendationsState: RequestState.Empty,
					movieRecommendations: const <Movie>[],
					isAddedtoWatchlist: false,
					watchlistMessage: ''
			);
			when(() => movieDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const MovieDetailPage(id: 1)
				),
				const Duration(seconds: 3)
			);

			// Expect
			expect(find.byType(CircularProgressIndicator), findsOneWidget);
		});
		testWidgets('should display error text when failed to retrieve movie data', (WidgetTester tester) async {

			// Arrange
			const movieId = 1;
			const message = 'failed fetchMovieDetail';
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => Left(ServerFailure(message)));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => Left(ServerFailure('failed loadWatchlistStatus')));
			final mockedState = MovieDetailState(
					message: message,
					movieDetailState: RequestState.Error,
					movieDetail: mockedMovieDetail,
					movieRecommendationsState: RequestState.Error,
					movieRecommendations: const <Movie>[],
					isAddedtoWatchlist: false,
					watchlistMessage: ''
			);
			when(() => movieDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const MovieDetailPage(id: 1)
				),
				const Duration(seconds: 3)
			);

			// Expect
			expect(find.text(message), findsOneWidget);
		});
		testWidgets('should display container when empty retrieve movie data', (WidgetTester tester) async {

			// Arrange
			const movieId = 1;
			const message = 'failed';
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => Left(ServerFailure(message)));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => Left(ServerFailure(message)));
			final mockedState = MovieDetailState(
					message: message,
					movieDetailState: RequestState.Empty,
					movieDetail: null,
					movieRecommendationsState: RequestState.Error,
					movieRecommendations: const <Movie>[],
					isAddedtoWatchlist: false,
					watchlistMessage: ''
			);
			when(() => movieDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const MovieDetailPage(id: 1)
				),
				const Duration(seconds: 3)
			);

			// Expect
			expect(find.byType(Container), findsOneWidget);
		});

		testWidgets('Watchlist button should display add icon when movie not added to watchlist', (WidgetTester tester) async {

			// Arrange
			const movieId = 1;
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = MovieDetailState(
				message: '',
				movieDetailState: RequestState.Loaded,
				movieDetail: mockedMovieDetail,
				movieRecommendationsState: RequestState.Loaded,
				movieRecommendations: const <Movie>[],
				isAddedtoWatchlist: false,
				watchlistMessage: '',
			);
			when(() => movieDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const MovieDetailPage(id: 1)
				),
			);

			// Expect
			expect(find.byIcon(Icons.add), findsOneWidget);
		});

		testWidgets('Watchlist button should display snackbar added to watchlist', (WidgetTester tester) async {

			// Arrange
			const movieId = 1;
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.addWatchlist(mockedMovieDetail))
				.thenAnswer((_) async => const Right(MovieDetailCubit.watchlistAddSuccessMessage));
			final mockedState = MovieDetailState(
				message: '',
				movieDetailState: RequestState.Loaded,
				movieDetail: mockedMovieDetail,
				movieRecommendationsState: RequestState.Loaded,
				movieRecommendations: const <Movie>[],
				isAddedtoWatchlist: false,
				watchlistMessage: ''
			);

			whenListen(
				movieDetailCubit,
				Stream.fromIterable([
					mockedState.copyWith(
						isAddedtoWatchlist: false,
						watchlistMessage: '',
					),
					mockedState.copyWith(
						isAddedtoWatchlist: true,
						watchlistMessage: MovieDetailCubit.watchlistAddSuccessMessage,
					),
				]),
				initialState: mockedState,
			);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const MovieDetailPage(id: 1)
				),
			);
			await tester.tap(find.byType(ElevatedButton));
    	await tester.pump();

			// Expect
			verify(() => movieDetailCubit.addWatchlist(mockedMovieDetail)).called(1);
			expect(find.byType(SnackBar), findsOneWidget);
			expect(find.text(MovieDetailCubit.watchlistAddSuccessMessage), findsOneWidget);
		});

		testWidgets('Watchlist button should display check icon when movie is added on watchlist', (WidgetTester tester) async {

			// Arrange
			const movieId = 1;
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = MovieDetailState(
				message: '',
				movieDetailState: RequestState.Loaded,
				movieDetail: mockedMovieDetail,
				movieRecommendationsState: RequestState.Loaded,
				movieRecommendations: const <Movie>[],
				isAddedtoWatchlist: true,
				watchlistMessage: '',
			);
			when(() => movieDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const MovieDetailPage(id: 1)
				),
			);

			// Expect
			expect(find.byIcon(Icons.check), findsOneWidget);
		});

		testWidgets('Watchlist button should display snackbar remove from watchlist', (WidgetTester tester) async {

			// Arrange
			const movieId = 1;
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.removeFromWatchlist(movieId))
				.thenAnswer((_) async => const Right(MovieDetailCubit.watchlistRemoveSuccessMessage));

			final mockedState = MovieDetailState(
				message: '',
				movieDetailState: RequestState.Loaded,
				movieDetail: mockedMovieDetail,
				movieRecommendationsState: RequestState.Loaded,
				movieRecommendations: const <Movie>[],
				isAddedtoWatchlist: true,
				watchlistMessage: ''
			);

			whenListen(
				movieDetailCubit,
				Stream.fromIterable([
					mockedState.copyWith(
						isAddedtoWatchlist: true,
						watchlistMessage: '',
					),
					mockedState.copyWith(
						isAddedtoWatchlist: false,
						watchlistMessage: MovieDetailCubit.watchlistRemoveSuccessMessage,
					),
				]),
				initialState: mockedState,
			);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const MovieDetailPage(id: 1)
				),
			);
			await tester.tap(find.byType(ElevatedButton));
    	await tester.pump();

			// Expect
			verify(() => movieDetailCubit.removeFromWatchlist(movieId)).called(1);
			expect(find.byType(SnackBar), findsOneWidget);
			expect(find.text(MovieDetailCubit.watchlistRemoveSuccessMessage), findsOneWidget);
		});

		testWidgets('Watchlist button should display AlertDialog if add from watchlist is failed', (WidgetTester tester) async {

			// Arrange
			const movieId = 1;
			const message = 'Failed';
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => const Right(true));

			final mockedState = MovieDetailState(
				message: '',
				movieDetailState: RequestState.Loaded,
				movieDetail: mockedMovieDetail,
				movieRecommendationsState: RequestState.Loaded,
				movieRecommendations: const <Movie>[],
				isAddedtoWatchlist: false,
				watchlistMessage: ''
			);

			whenListen(
				movieDetailCubit,
				Stream.fromIterable([
					mockedState.copyWith(
						isAddedtoWatchlist: false,
					),
					mockedState.copyWith(
						isAddedtoWatchlist: false,
						watchlistMessage: message,
					),
				]),
				initialState: mockedState,
			);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const MovieDetailPage(id: 1)
				),
			);
			expect(find.byType(AlertDialog), findsNothing);
			expect(find.text(message), findsNothing);

			await tester.tap(find.byType(ElevatedButton));
    	await tester.pump();

			// Expect
			expect(find.byType(AlertDialog), findsOneWidget);
			expect(find.text(message), findsOneWidget);
		});

		testWidgets('Watchlist button should display AlertDialog if remove from watchlist is failed', (WidgetTester tester) async {

			// Arrange
			const movieId = 1;
			const message = 'Failed';
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => const Right(true));

			final mockedState = MovieDetailState(
				message: '',
				movieDetailState: RequestState.Loaded,
				movieDetail: mockedMovieDetail,
				movieRecommendationsState: RequestState.Loaded,
				movieRecommendations: const <Movie>[],
				isAddedtoWatchlist: true,
				watchlistMessage: ''
			);

			whenListen(
				movieDetailCubit,
				Stream.fromIterable([
					mockedState.copyWith(
						isAddedtoWatchlist: true,
					),
					mockedState.copyWith(
						isAddedtoWatchlist: true,
						watchlistMessage: message,
					),
				]),
				initialState: mockedState,
			);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const MovieDetailPage(id: 1)
				),
			);
			expect(find.byType(AlertDialog), findsNothing);
			expect(find.text(message), findsNothing);

			await tester.tap(find.byType(ElevatedButton));
    	await tester.pump();

			// Expect
			expect(find.byType(AlertDialog), findsOneWidget);
			expect(find.text(message), findsOneWidget);
		});

		// Recommendation
		
		testWidgets(
      'show CircularProgressIndicator when movie recommendations still loading from server',
          (WidgetTester tester) async {
				// Arrange
				const movieId = 1;
				when(() => movieDetailCubit.fetchMovieDetail(movieId))
					.thenAnswer((_) async => const Right(true));
				when(() => movieDetailCubit.loadWatchlistStatus(movieId))
					.thenAnswer((_) async => const Right(true));
        final mockedState = MovieDetailState(
            message: '',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Loading,
            movieRecommendations: const <Movie>[],
            isAddedtoWatchlist: false,
            watchlistMessage: ''
        );
				when(() => movieDetailCubit.state).thenReturn(mockedState);

				// Act
        await tester.pumpWidget(
            _makeTestableWidget(const MovieDetailPage(id: 1)),
        );

				// Expect
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  	testWidgets('should display empty container when empty to retrieve movie recommendations data', (WidgetTester tester) async {
			// Rearrange
			const movieId = 1;
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = MovieDetailState(
					message: 'Failed',
					movieDetailState: RequestState.Loaded,
					movieDetail: mockedMovieDetail,
					movieRecommendationsState: RequestState.Error,
					movieRecommendations: const <Movie>[],
					isAddedtoWatchlist: false,
					watchlistMessage: ''
			);
			when(() => movieDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
					_makeTestableWidget(const MovieDetailPage(id: 1)),
					const Duration(seconds: 3)
			);

			// Expect
			final recommendationsContainer = find.byKey(const Key('movie_recommendations_empty'));
			expect(recommendationsContainer, findsOneWidget);
		});

  	testWidgets('should display loaded container when success to retrieve movie recommendations data', (WidgetTester tester) async {
			// Rearrange
			const movieId = 1;
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = MovieDetailState(
					message: 'Success',
					movieDetailState: RequestState.Loaded,
					movieDetail: mockedMovieDetail,
					movieRecommendationsState: RequestState.Loaded,
					movieRecommendations: <Movie>[mockedMovie],
					isAddedtoWatchlist: false,
					watchlistMessage: ''
			);
			when(() => movieDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
					_makeTestableWidget(const MovieDetailPage(id: 1)),
					const Duration(seconds: 3)
			);

			// Expect
			final recommendationsContainer = find.byKey(const Key('movie_recommendations_loaded'));
			expect(recommendationsContainer, findsOneWidget);
		});

		testWidgets('should call Navigator.pop', (WidgetTester tester) async {
			// Rearrange
			const movieId = 1;
			when(() => movieDetailCubit.fetchMovieDetail(movieId))
				.thenAnswer((_) async => const Right(true));
			when(() => movieDetailCubit.loadWatchlistStatus(movieId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = MovieDetailState(
					message: 'Success',
					movieDetailState: RequestState.Loaded,
					movieDetail: mockedMovieDetail,
					movieRecommendationsState: RequestState.Loaded,
					movieRecommendations: <Movie>[mockedMovie],
					isAddedtoWatchlist: false,
					watchlistMessage: ''
			);
			when(() => movieDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
					_makeTestableWidget(const MovieDetailPage(id: 1)),
					const Duration(seconds: 3)
			);
			final backButton = find.byIcon(Icons.arrow_back);
			await tester.tap(backButton);
			await tester.pumpAndSettle();

			// Expect
			verify(() => mockObserver.didPop(any(), any())).called(1);
		});

		// testWidgets('should call Navigator.pushReplacementNamed', (WidgetTester tester) async {
		// 	// Rearrange
		// 	const movieId = 1;
		// 	when(() => movieDetailCubit.fetchMovieDetail(movieId))
		// 		.thenAnswer((_) async => const Right(true));
		// 	when(() => movieDetailCubit.loadWatchlistStatus(movieId))
		// 		.thenAnswer((_) async => const Right(true));
		// 	final mockedState = MovieDetailState(
		// 			message: 'Success',
		// 			movieDetailState: RequestState.Loaded,
		// 			movieDetail: mockedMovieDetail,
		// 			movieRecommendationsState: RequestState.Loaded,
		// 			movieRecommendations: <Movie>[mockedMovie],
		// 			isAddedtoWatchlist: false,
		// 			watchlistMessage: ''
		// 	);
		// 	when(() => movieDetailCubit.state).thenReturn(mockedState);

		// 	// Act
		// 	await tester.pumpWidget(
		// 			_makeTestableWidget(const MovieDetailPage(id: 1)),
		// 			const Duration(seconds: 3)
		// 	);
		// 	final item = find.byKey(const Key('movie_recommendation_item')).first;
		// 	await tester.tap(item);
		// 	await tester.pumpAndSettle();

		// 	// Expect
		// 	verify(() => mockObserver.didPush(any(), any()));
		// 	expect(find.byType(MovieDetailPage), findsOneWidget);
		// });
	});
}