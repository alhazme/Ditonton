import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_top_rated_cubit.dart';
import 'package:movie/presentation/bloc/movie_top_rated_state.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/widget/movie_card.dart';

import '../../dummy_data/dummy_objects.dart';

class MockedMovieTopRatedCubit extends MockCubit<MovieTopRatedState> implements MovieTopRatedCubit {}
void main() {

  late MovieTopRatedCubit movieTopRatedCubit;

  setUp(() {
    movieTopRatedCubit = MockedMovieTopRatedCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieTopRatedCubit>(
      create: (_) => movieTopRatedCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

	group('MovieTopRatedPageTest', () {

		testWidgets('Page should display progress bar when loading', (WidgetTester tester) async {

			// Rearrange
			const mockedState = MovieTopRatedState(
				message: "",
				topRatedMoviesState: RequestState.Loading,
				topRatedMovies: <Movie>[],
			);
			when(() => movieTopRatedCubit.state).thenReturn(mockedState);
			when(() => movieTopRatedCubit.fetchTopRatedMovies())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

			// Expect
			final progressFinder = find.byType(CircularProgressIndicator);
			final centerFinder = find.byType(Center);
			expect(centerFinder, findsOneWidget);
			expect(progressFinder, findsOneWidget);
		});

		testWidgets('Page should display when data is loaded', (WidgetTester tester) async {

			// Rearrange
			MovieTopRatedState mockedState = MovieTopRatedState(
				message: "",
				topRatedMoviesState: RequestState.Loaded,
				topRatedMovies: mockedMovieList,
			);
			mockedState.copyWith(topRatedMovies: mockedMovieList);
			when(() => movieTopRatedCubit.state).thenReturn(mockedState);
			when(() => movieTopRatedCubit.fetchTopRatedMovies())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

			// Expect
			final listViewFinder = find.byType(ListView);
			expect(listViewFinder, findsOneWidget);
			expect(find.byType(MovieCard), findsNWidgets(mockedMovieList.length));
		});

		testWidgets('Page should display text with message when Error', (WidgetTester tester) async {

			// Rearrange
			final mockedState = MovieTopRatedState(
				message: 'Error message',
				topRatedMoviesState: RequestState.Error,
				topRatedMovies: [mockedMovie],
			);
			when(() => movieTopRatedCubit.state).thenReturn(mockedState);
			when(() => movieTopRatedCubit.fetchTopRatedMovies())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

			// Expect
			final textFinder = find.byKey(const Key('error_message'));
			expect(textFinder, findsOneWidget);
		});

	});

}