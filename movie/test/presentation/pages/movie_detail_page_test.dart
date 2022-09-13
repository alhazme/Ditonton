/*
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:movie/presentation/bloc/movie_detail_state.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:ui' as ui;

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../movie/test/presentation/pages/movie_detail_page_test.mocks.dart';

class MockMovieDetailCubit extends MockCubit<MovieDetailState> implements MovieDetailCubit {}
class MovieDetailStateFake extends Fake implements MovieDetailState {}

// @GenerateMocks([MovieDetailCubit])//, MovieDetailNotifier])
void main() {
  late MockMovieDetailCubit mockMovieDetailCubit;
  // MovieDetailState initialState;
  // late MovieDetailStateFake movieDetailStateFake;
  // late MovieDetailState movieDetailState;
  // late MockMovieDetailNotifier mockNotifier;

  setUpAll(() {
    registerFallbackValue(MovieDetailStateFake());
  });

  setUp(() {
    mockMovieDetailCubit = MockMovieDetailCubit();

    // movieDetailStateFake = MovieDetailStateFake();
    final initialState = MovieDetailState(
      message: '',
      movieDetailState: RequestState.Empty,
      movieDetail: mockedMovieDetail,
      movieRecommendationsState: RequestState.Empty,
      movieRecommendations: <Movie>[],
      isAddedtoWatchlist: false,
      watchlistMessage: ''
    );
    when(() => mockMovieDetailCubit.state).thenReturn(initialState);
    // movieDetailState = mockMovieDetailCubit.state;
    // mockNotifier = MockMovieDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailCubit>(
      create: (_) => mockMovieDetailCubit,
      child: MediaQuery(
        data: MediaQueryData.fromWindow(ui.window),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: body,
        ),
      ),
    );
    // return MultiBlocProvider(
    //     providers: [
    //       BlocProvider<MovieDetailCubit>(
    //         create: (_) => mockMovieDetailCubit,
    //         child: body,
    //       )
    //     ],
    //     child: MaterialApp(
    //       home: body,
    //     )
    // );
    // return ChangeNotifierProvider<MovieDetailNotifier>.value(
    //   value: mockNotifier,
    //   child: MaterialApp(
    //     home: body,
    //   ),
    // );
  }

  // Movie

  testWidgets(
      'show CircularProgressIndicator when movies still loading from server',
          (WidgetTester tester) async {
            final initialState = MovieDetailState(
                message: '',
                movieDetailState: RequestState.Loading,
                movieDetail: mockedMovieDetail,
                movieRecommendationsState: RequestState.Empty,
                movieRecommendations: <Movie>[],
                isAddedtoWatchlist: false,
                watchlistMessage: ''
            );
            when(() => mockMovieDetailCubit.state)
                .thenReturn(initialState);
            // when(mockMovieDetailCubit.state).thenReturn(mockedState);
        // when(mockMovieDetailCubit.state).thenAnswer((_) => initialState);
        // when(mockMovieDetailCubit.getMovieDetail)
        //     .thenAnswer((_) => Left(ServerFailure('failed fetchMovieDetail')));
        // when(mockMovieDetailCubit.state.message).thenReturn('');
        // when(mockMovieDetailCubit.state.movieDetailState).thenReturn(RequestState.Loading);
        // when(mockMovieDetailCubit.state.movieDetail).thenReturn(mockedMovieDetail);
        // when(mockMovieDetailCubit.state.movieRecommendationsState).thenReturn(RequestState.Loading);
        // when(mockMovieDetailCubit.state.movieRecommendations).thenReturn(<Movie>[]);
        // when(mockMovieDetailCubit.state.isAddedtoWatchlist).thenReturn(false);
        // MovieDetailState initialState = MovieDetailState(
        //     message: '',
        //     movieDetailState: RequestState.Loading,
        //     movieDetail: null,
        //     movieRecommendationsState: RequestState.Empty,
        //     movieRecommendations: <Movie>[],
        //     isAddedtoWatchlist: false,
        //     watchlistMessage: ''
        // );
        // when(mockMovieDetailCubit.state).thenReturn(initialState);
        // when(() => mockMovieDetailCubit.state.movieDetailState)
        //     .thenReturn(RequestState.Loading);

        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expectLater(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets(
      'should display error text when failed to retrieve movie data',
          (WidgetTester tester) async {
        when(mockNotifier.movieState).thenReturn(RequestState.Error);
        when(mockNotifier.movie).thenReturn(mockedMovieDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
        when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.message).thenReturn('Failed');

        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.text('Failed'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(mockedMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(mockedMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(mockedMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(mockedMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist',
  (WidgetTester tester) async {
    when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movie).thenReturn(mockedMovieDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockNotifier.watchlistMessage).thenReturn('Removed from Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movie).thenReturn(mockedMovieDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(true);
        when(mockNotifier.watchlistMessage).thenReturn('Failed');

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(find.byIcon(Icons.check), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });

  // Recommendations

  testWidgets(
      'show CircularProgressIndicator when tvs still loading from server',
          (WidgetTester tester) async {
        when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movie).thenReturn(mockedMovieDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loading);
        when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        const testKey = Key('movie_recommendations_loading');

        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.byKey(testKey), findsOneWidget);
      });

  testWidgets(
      'should display error text when failed to retrieve tv recommendations data',
          (WidgetTester tester) async {
        when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movie).thenReturn(mockedMovieDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
        when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.message).thenReturn('Failed retrieve tv recommendations');

        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.text('Failed retrieve tv recommendations'), findsOneWidget);
      });

  testWidgets(
      'should display error text when empty to retrieve tv recommendations data',
          (WidgetTester tester) async {
        when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movie).thenReturn(mockedMovieDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Empty);
        when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.message).thenReturn('Failed');
        const testKey = Key('movie_recommendations_empty');
        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.byKey(testKey), findsOneWidget);
      });

  testWidgets(
      'show tvs recommendation when tvs loaded from server',
          (WidgetTester tester) async {
        when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movie).thenReturn(mockedMovieDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.movieRecommendations).thenReturn([mockedMovie]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        const testKey = Key('movie_recommendations_loaded_image');

        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.byKey(testKey), findsOneWidget);
      });
}
*/
