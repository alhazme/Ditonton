import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_top_rated_cubit.dart';
import 'package:movie/presentation/bloc/movie_top_rated_state.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../movie/test/presentation/pages/top_rated_movies_page_test.mocks.dart';

@GenerateMocks([MovieTopRatedCubit])
void main() {

  late MockMovieTopRatedCubit mockMovieTopRatedCubit;

  setUp(() {
    mockMovieTopRatedCubit = MockMovieTopRatedCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieTopRatedCubit>(
      create: (_) => mockMovieTopRatedCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    final mockedState = MovieTopRatedState(
      message: "",
      topRatedMoviesState: RequestState.Loading,
      topRatedMovies: <Movie>[],
    );
    when(mockMovieTopRatedCubit.stream)
        .thenAnswer((_) => Stream.value(mockedState));
    when(mockMovieTopRatedCubit.state)
        .thenReturn(mockedState);

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    final mockedState = MovieTopRatedState(
      message: "",
      topRatedMoviesState: RequestState.Loaded,
      topRatedMovies: [mockedMovie],
    );
    when(mockMovieTopRatedCubit.stream)
        .thenAnswer((_) => Stream.value(mockedState));
    when(mockMovieTopRatedCubit.state)
        .thenReturn(mockedState);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    final mockedState = MovieTopRatedState(
      message: 'Error message',
      topRatedMoviesState: RequestState.Error,
      topRatedMovies: [mockedMovie],
    );
    when(mockMovieTopRatedCubit.stream)
        .thenAnswer((_) => Stream.value(mockedState));
    when(mockMovieTopRatedCubit.state)
        .thenReturn(mockedState);

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}