import 'package:core/core.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_home_cubit.dart';
import 'package:movie/presentation/bloc/movie_home_state.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'dart:ui' as ui;

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.dart';
import '../../../../movie/test/presentation/pages/home_movie_page_test.mocks.dart';

@GenerateMocks([MovieHomeCubit])
void main() {
  late MockMovieHomeCubit mockMovieHomeCubit;
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockMovieHomeCubit = MockMovieHomeCubit();
    mockObserver = MockNavigatorObserver();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieHomeCubit>(
      create: (_) => mockMovieHomeCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {

    final mockedState = MovieHomeState(
      message: '',
      nowPlayingState: RequestState.Loading,
      nowPlayingMovies: <Movie>[],
      popularMoviesState: RequestState.Loading,
      popularMovies: <Movie>[],
      topRatedMoviesState:  RequestState.Loading,
      topRatedMovies: <Movie>[]
    );

    when(mockMovieHomeCubit.stream)
        .thenAnswer((_) => Stream.value(mockedState));
    when(mockMovieHomeCubit.state)
        .thenReturn(mockedState);

    final nowPlayingProgressIndicator = find.byKey(Key('now_playing_progress_indicator'));
    final popularProgressIndicator = find.byKey(Key('popular_progress_indicator'));
    final topRatedProgressIndicator = find.byKey(Key('top_rated_progress_indicator'));

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(nowPlayingProgressIndicator, findsOneWidget);
    expect(popularProgressIndicator, findsOneWidget);
    expect(topRatedProgressIndicator, findsOneWidget);
  });

  testWidgets('Page should display list when data loaded',
      (WidgetTester tester) async {

    final mockedState = MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Loaded,
        nowPlayingMovies: [mockedMovie],
        popularMoviesState: RequestState.Loaded,
        popularMovies: [mockedMovie],
        topRatedMoviesState:  RequestState.Loaded,
        topRatedMovies: [mockedMovie]
    );

    when(mockMovieHomeCubit.stream)
        .thenAnswer((_) => Stream.value(mockedState));
    when(mockMovieHomeCubit.state)
        .thenReturn(mockedState);

    final nowPlayingMovieList = find.byKey(Key('now_playing_movies'));
    final popularMovieList = find.byKey(Key('popular_movies'));
    final topRatedMovieList = find.byKey(Key('top_rated_movies'));

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(nowPlayingMovieList, findsOneWidget);
    expect(popularMovieList, findsOneWidget);
    expect(topRatedMovieList, findsOneWidget);
  });

  testWidgets('Page should display list drawer',
      (WidgetTester tester) async {

    final mockedState = MovieHomeState(
        message: '',
        nowPlayingState: RequestState.Loaded,
        nowPlayingMovies: [mockedMovie],
        popularMoviesState: RequestState.Loaded,
        popularMovies: [mockedMovie],
        topRatedMoviesState:  RequestState.Loaded,
        topRatedMovies: [mockedMovie]
    );

    when(mockMovieHomeCubit.stream)
        .thenAnswer((_) => Stream.value(mockedState));
    when(mockMovieHomeCubit.state)
        .thenReturn(mockedState);

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    // final homeDrawer = find.byKey(Key('home_drawer'));
    await tester.dragFrom(tester.getTopLeft(find.byType(MaterialApp)), Offset(300, 0));
    await tester.pump();

    final movieDrawerListTitle = find.text("Movies");
    await tester.tap(movieDrawerListTitle);
    await tester.pump();

    // verify(mockObserver.didPop(any!, any));
    expect(find.byType(HomeMoviePage), findsOneWidget);

  });


}