import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_detail_cubit.dart';
import 'package:tv/presentation/bloc/tv_detail_state.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'dart:ui' as ui;

import '../../dummy_data/dummy_objects.dart';

class MockedTVDetailCubit extends MockCubit<TVDetailState> implements TVDetailCubit {}

void main() {
	late TVDetailCubit tvDetailCubit;

	setUp(() {
		tvDetailCubit = MockedTVDetailCubit();
	});

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TVDetailCubit>(
      create: (_) => tvDetailCubit,
      child: MediaQuery(
        data: MediaQueryData.fromWindow(ui.window),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
						home: body,
					),
        ),
      ),
    );
	}

	group('TVDetailPageTest', () {
		testWidgets('show CircularProgressIndicator when tvs still loading from server', (WidgetTester tester) async {

			// Arrange
			const tvId = 1;
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => Left(ServerFailure('failed fetchTVDetail')));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => Left(ServerFailure('failed loadWatchlistStatus')));
			final mockedState = TVDetailState(
        message: '',
        tvDetailState: RequestState.Loading,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Empty,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ''
			);
			when(() => tvDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const TVDetailPage(id: 1)
				),
				const Duration(seconds: 3)
			);

			// Expect
			expect(find.byType(CircularProgressIndicator), findsOneWidget);
		});
		testWidgets('should display error text when failed to retrieve tv data', (WidgetTester tester) async {

			// Arrange
			const tvId = 1;
			const message = 'failed fetchTVDetail';
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => Left(ServerFailure(message)));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => Left(ServerFailure('failed loadWatchlistStatus')));
			final mockedState = TVDetailState(
        message: message,
        tvDetailState: RequestState.Error,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Error,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ''
			);
			when(() => tvDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const TVDetailPage(id: 1)
				),
				const Duration(seconds: 3)
			);

			// Expect
			expect(find.text(message), findsOneWidget);
		});
		testWidgets('should display container when empty retrieve tv data', (WidgetTester tester) async {

			// Arrange
			const tvId = 1;
			const message = 'failed';
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => Left(ServerFailure(message)));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => Left(ServerFailure('failed loadWatchlistStatus')));
			final mockedState = TVDetailState(
        message: message,
        tvDetailState: RequestState.Empty,
        tvDetail: null,
        tvRecommendationsState: RequestState.Error,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ''
			);
			when(() => tvDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const TVDetailPage(id: 1)
				),
				const Duration(seconds: 3)
			);

			// Expect
			expect(find.byType(Container), findsOneWidget);
		});

		testWidgets('Watchlist button should display add icon when tv not added to watchlist', (WidgetTester tester) async {

			// Arrange
			const tvId = 1;
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => const Right(true));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = TVDetailState(
        message: '',
        tvDetailState: RequestState.Loaded,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ''
			);
			when(() => tvDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const TVDetailPage(id: 1)
				),
			);

			// Expect
			expect(find.byIcon(Icons.add), findsOneWidget);
		});

		testWidgets('Watchlist button should display snackbar added to watchlist', (WidgetTester tester) async {

			// Arrange
			const tvId = 1;
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => const Right(true));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => const Right(true));
			when(() => tvDetailCubit.addWatchlist(mockedTVDetail))
				.thenAnswer((_) async => const Right(TVDetailCubit.watchlistAddSuccessMessage));
			final mockedState = TVDetailState(
        message: '',
        tvDetailState: RequestState.Loaded,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ''
			);

			whenListen(
				tvDetailCubit,
				Stream.fromIterable([
					mockedState.copyWith(
						isAddedtoWatchlist: false,
						watchlistMessage: '',
					),
					mockedState.copyWith(
						isAddedtoWatchlist: true,
						watchlistMessage: TVDetailCubit.watchlistAddSuccessMessage,
					),
				]),
				initialState: mockedState,
			);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const TVDetailPage(id: 1)
				),
			);
			await tester.tap(find.byType(ElevatedButton));
    	await tester.pump();

			// Expect
			verify(() => tvDetailCubit.addWatchlist(mockedTVDetail)).called(1);
			expect(find.byType(SnackBar), findsOneWidget);
			expect(find.text(TVDetailCubit.watchlistAddSuccessMessage), findsOneWidget);
		});

		testWidgets('Watchlist button should display check icon when tv is added on watchlist', (WidgetTester tester) async {

			// Arrange
			const tvId = 1;
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => const Right(true));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = TVDetailState(
        message: '',
        tvDetailState: RequestState.Loaded,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: true,
        watchlistMessage: ''
			);
			when(() => tvDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const TVDetailPage(id: 1)
				),
			);

			// Expect
			expect(find.byIcon(Icons.check), findsOneWidget);
		});

		testWidgets('Watchlist button should display snackbar remove from watchlist', (WidgetTester tester) async {

			// Arrange
			const tvId = 1;
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => const Right(true));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => const Right(true));
			when(() => tvDetailCubit.removeFromWatchlist(tvId))
				.thenAnswer((_) async => const Right(TVDetailCubit.watchlistRemoveSuccessMessage));

			final mockedState = TVDetailState(
        message: '',
        tvDetailState: RequestState.Loaded,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: true,
        watchlistMessage: ''
			);

			whenListen(
				tvDetailCubit,
				Stream.fromIterable([
					mockedState.copyWith(
						isAddedtoWatchlist: true,
						watchlistMessage: '',
					),
					mockedState.copyWith(
						isAddedtoWatchlist: false,
						watchlistMessage: TVDetailCubit.watchlistRemoveSuccessMessage,
					),
				]),
				initialState: mockedState,
			);

			// Act
			await tester.pumpWidget(
				_makeTestableWidget(
					const TVDetailPage(id: 1)
				),
			);
			await tester.tap(find.byType(ElevatedButton));
    	await tester.pump();

			// Expect
			verify(() => tvDetailCubit.removeFromWatchlist(tvId)).called(1);
			expect(find.byType(SnackBar), findsOneWidget);
			expect(find.text(TVDetailCubit.watchlistRemoveSuccessMessage), findsOneWidget);
		});

		testWidgets('Watchlist button should display AlertDialog if add from watchlist is failed', (WidgetTester tester) async {

			// Arrange
			const tvId = 1;
			const message = 'Failed';
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => const Right(true));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = TVDetailState(
        message: '',
        tvDetailState: RequestState.Loaded,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ''
			);

			whenListen(
				tvDetailCubit,
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
					const TVDetailPage(id: 1)
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
			const tvId = 1;
			const message = 'Failed';
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => const Right(true));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = TVDetailState(
        message: '',
        tvDetailState: RequestState.Loaded,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: true,
        watchlistMessage: ''
			);

			whenListen(
				tvDetailCubit,
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
					const TVDetailPage(id: 1)
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
      'show CircularProgressIndicator when tv recommendations still loading from server',
          (WidgetTester tester) async {
				// Arrange
				const tvId = 1;
				when(() => tvDetailCubit.fetchTVDetail(tvId))
					.thenAnswer((_) async => const Right(true));
				when(() => tvDetailCubit.loadWatchlistStatus(tvId))
					.thenAnswer((_) async => const Right(true));
			final mockedState = TVDetailState(
        message: '',
        tvDetailState: RequestState.Loaded,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ''
			);
				when(() => tvDetailCubit.state).thenReturn(mockedState);

				// Act
        await tester.pumpWidget(
            _makeTestableWidget(const TVDetailPage(id: 1)),
        );

				// Expect
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  	testWidgets('should display empty container when empty to retrieve tv recommendations data', (WidgetTester tester) async {
			// Rearrange
			const tvId = 1;
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => const Right(true));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = TVDetailState(
        message: 'Failed',
        tvDetailState: RequestState.Loaded,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Error,
        tvRecommendations: const <TV>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ''
			);
			when(() => tvDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
					_makeTestableWidget(const TVDetailPage(id: 1)),
					const Duration(seconds: 3)
			);

			// Expect
			final recommendationsContainer = find.byKey(const Key('tv_recommendations_empty'));
			expect(recommendationsContainer, findsOneWidget);
		});

  	testWidgets('should display loaded container when success to retrieve tv recommendations data', (WidgetTester tester) async {
			// Rearrange
			const tvId = 1;
			when(() => tvDetailCubit.fetchTVDetail(tvId))
				.thenAnswer((_) async => const Right(true));
			when(() => tvDetailCubit.loadWatchlistStatus(tvId))
				.thenAnswer((_) async => const Right(true));
			final mockedState = TVDetailState(
        message: 'Success',
        tvDetailState: RequestState.Loaded,
        tvDetail: mockedTVDetail,
        tvRecommendationsState: RequestState.Loaded,
        tvRecommendations: <TV>[mockedTV],
        isAddedtoWatchlist: false,
        watchlistMessage: ''
			);
			when(() => tvDetailCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(
					_makeTestableWidget(const TVDetailPage(id: 1)),
					const Duration(seconds: 3)
			);

			// Expect
			final recommendationsContainer = find.byKey(const Key('tv_recommendations_loaded'));
			expect(recommendationsContainer, findsOneWidget);
		});

	});

}