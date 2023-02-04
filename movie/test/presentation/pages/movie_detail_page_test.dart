import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/save_movie_watchlist.dart';
import 'package:movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:movie/presentation/bloc/movie_detail_state.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
// import 'package:mocktail/mocktail.dart';
import 'dart:ui' as ui;

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../movie/test/presentation/pages/movie_detail_page_test.mocks.dart';

// class MockMovieDetailCubit extends MockCubit<MovieDetailState> implements MovieDetailCubit {}
// class MovieDetailStateFake extends Fake implements MovieDetailState {}
@GenerateMocks([MovieDetailCubit])//, MovieDetailNotifier])
// @GenerateMocks([MovieDetailCubit], customMocks: [MockSpec<MovieDetailState>()])//, MovieDetailNotifier])
// @GenerateNiceMocks([MockSpec<MovieDetailCubit>()]) //([MovieDetailCubit])//, MovieDetailNotifier])
// @GenerateMocks([
//   GetMovieDetail,
//   GetMovieRecommendations,
//   GetWatchListStatus,
//   SaveMovieWatchlist,
//   RemoveWatchlist,
// ])
void main() {
  late MockMovieDetailCubit mockMovieDetailCubit;
  setUp(() {
    mockMovieDetailCubit = MockMovieDetailCubit();
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
            final mockedState = MovieDetailState(
                message: '',
                movieDetailState: RequestState.Loading,
                movieDetail: mockedMovieDetail,
                movieRecommendationsState: RequestState.Empty,
                movieRecommendations: <Movie>[],
                isAddedtoWatchlist: false,
                watchlistMessage: ''
            );
            when(mockMovieDetailCubit.stream)
                .thenAnswer((_) => Stream.value(mockedState));
            when(mockMovieDetailCubit.state)
                .thenReturn(mockedState);
            // when(() => mockMovieDetailCubit.state.movieDetail).thenReturn(mockedMovieDetail);
            // when(mockMovieDetailCubit.fetchMovieDetail(1))
            //     .thenAnswer((_) async => Left(ServerFailure('failed fetchMovieDetail')));
            // when(mockMovieDetailCubit.state).thenReturn(initialState);
            // when(movieDetailCubit.state)
            //     .thenReturn(initialState);
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

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets(
      'should display error text when failed to retrieve movie data',
          (WidgetTester tester) async {
            final mockedState = MovieDetailState(
                message: 'Failed',
                movieDetailState: RequestState.Error,
                movieDetail: mockedMovieDetail,
                movieRecommendationsState: RequestState.Error,
                movieRecommendations: <Movie>[],
                isAddedtoWatchlist: false,
                watchlistMessage: ''
            );
            when(mockMovieDetailCubit.stream)
                .thenAnswer((_) => Stream.value(mockedState));
            when(mockMovieDetailCubit.state)
                .thenReturn(mockedState);

        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.text('Failed'), findsOneWidget);
      });


  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
          (WidgetTester tester) async {
        final mockedState = MovieDetailState(
            message: '',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Loaded,
            movieRecommendations: <Movie>[],
            isAddedtoWatchlist: false,
            watchlistMessage: ''
        );
        when(mockMovieDetailCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMovieDetailCubit.state)
            .thenReturn(mockedState);

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
          (WidgetTester tester) async {
        final mockedState = MovieDetailState(
            message: '',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Loaded,
            movieRecommendations: <Movie>[],
            isAddedtoWatchlist: true,
            watchlistMessage: ''
        );
        when(mockMovieDetailCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMovieDetailCubit.state)
            .thenReturn(mockedState);

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });


  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        final mockedState = MovieDetailState(
            message: '',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Loaded,
            movieRecommendations: <Movie>[],
            isAddedtoWatchlist: false,
            watchlistMessage: MovieDetailCubit.watchlistAddSuccessMessage
        );
        when(mockMovieDetailCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMovieDetailCubit.state)
            .thenReturn(mockedState);


        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
        expect(find.byIcon(Icons.add), findsOneWidget);

        // final watchlistButton = find.byType(ElevatedButton);
        final watchlistButton = find.byKey(Key('watchlist_button'));
        await tester.tap(watchlistButton);
        await tester.pump(Duration(seconds: 3));

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(MovieDetailCubit.watchlistAddSuccessMessage), findsOneWidget);
      });

  /*
  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        final mockedState = MovieDetailState(
            message: '',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Loaded,
            movieRecommendations: <Movie>[],
            isAddedtoWatchlist: false,
            watchlistMessage: MovieDetailCubit.watchlistAddSuccessMessage
        );
        when(mockMovieDetailCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMovieDetailCubit.state)
            .thenReturn(mockedState);


        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
        expect(find.byIcon(Icons.add), findsOneWidget);

        // final watchlistButton = find.byType(ElevatedButton);
        final watchlistButton = find.byKey(Key('watchlist_button'));
        await tester.tap(watchlistButton);
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(MovieDetailCubit.watchlistAddSuccessMessage), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        final mockedState = MovieDetailState(
            message: '',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Loaded,
            movieRecommendations: <Movie>[],
            isAddedtoWatchlist: false,
            watchlistMessage: 'Failed'
        );
        when(mockMovieDetailCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMovieDetailCubit.state)
            .thenReturn(mockedState);

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
        final mockedState = MovieDetailState(
            message: '',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Loaded,
            movieRecommendations: <Movie>[],
            isAddedtoWatchlist: true,
            watchlistMessage: MovieDetailCubit.watchlistRemoveSuccessMessage
        );
        when(mockMovieDetailCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMovieDetailCubit.state)
            .thenReturn(mockedState);

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
        final mockedState = MovieDetailState(
            message: '',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Loaded,
            movieRecommendations: <Movie>[],
            isAddedtoWatchlist: true,
            watchlistMessage: 'Failed'
        );
        when(mockMovieDetailCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMovieDetailCubit.state)
            .thenReturn(mockedState);

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(find.byIcon(Icons.check), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });
*/

  // Recommendations

  testWidgets(
      'show CircularProgressIndicator when movie recommendations still loading from server',
          (WidgetTester tester) async {
        final mockedState = MovieDetailState(
            message: '',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Loading,
            movieRecommendations: <Movie>[],
            isAddedtoWatchlist: false,
            watchlistMessage: ''
        );
        when(mockMovieDetailCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMovieDetailCubit.state)
            .thenReturn(mockedState);

        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets(
      'should display empty container when empty to retrieve movie recommendations data',
          (WidgetTester tester) async {
        final mockedState = MovieDetailState(
            message: 'Failed',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Error,
            movieRecommendations: <Movie>[],
            isAddedtoWatchlist: false,
            watchlistMessage: ''
        );
        when(mockMovieDetailCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMovieDetailCubit.state)
            .thenReturn(mockedState);

        final recommendationsContainer = find.byKey(Key('movie_recommendations_empty'));

        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(recommendationsContainer, findsOneWidget);
      });

  testWidgets(
      'should display loaded container when success to retrieve movie recommendations data',
          (WidgetTester tester) async {
        final mockedState = MovieDetailState(
            message: 'Success',
            movieDetailState: RequestState.Loaded,
            movieDetail: mockedMovieDetail,
            movieRecommendationsState: RequestState.Loaded,
            movieRecommendations: <Movie>[mockedMovie],
            isAddedtoWatchlist: false,
            watchlistMessage: ''
        );
        when(mockMovieDetailCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMovieDetailCubit.state)
            .thenReturn(mockedState);

        final recommendationsContainer = find.byKey(Key('movie_recommendations_loaded'));

        await tester.pumpWidget(
            _makeTestableWidget(MovieDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(recommendationsContainer, findsOneWidget);
      });

/*
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

 */
/*
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
 */
}
