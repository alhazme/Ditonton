import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_popular_cubit.dart';
import 'package:movie/presentation/bloc/movie_popular_state.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/provider/popular_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../movie/test/presentation/pages/popular_movies_page_test.mocks.dart';

@GenerateMocks([MoviePopularCubit])
void main() {

  late MockMoviePopularCubit mockMoviePopularCubit;

  setUp(() {
    mockMoviePopularCubit = MockMoviePopularCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MoviePopularCubit>(
      create: (_) => mockMoviePopularCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
      final mockedState = MoviePopularState(
        message: "",
        popularMoviesState: RequestState.Loading,
        popularMovies: <Movie>[],
      );
      when(mockMoviePopularCubit.stream)
          .thenAnswer((_) => Stream.value(mockedState));
      when(mockMoviePopularCubit.state)
          .thenReturn(mockedState);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final mockedState = MoviePopularState(
      message: "",
      popularMoviesState: RequestState.Loaded,
      popularMovies: [mockedMovie],
    );
    when(mockMoviePopularCubit.stream)
        .thenAnswer((_) => Stream.value(mockedState));
    when(mockMoviePopularCubit.state)
        .thenReturn(mockedState);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
        final mockedState = MoviePopularState(
          message: 'Error message',
          popularMoviesState: RequestState.Error,
          popularMovies: [mockedMovie],
        );
        when(mockMoviePopularCubit.stream)
            .thenAnswer((_) => Stream.value(mockedState));
        when(mockMoviePopularCubit.state)
            .thenReturn(mockedState);

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}