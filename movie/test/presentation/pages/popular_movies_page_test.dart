
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_popular_cubit.dart';
import 'package:movie/presentation/bloc/movie_popular_state.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/widget/movie_card.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';

class MockedMoviePopularCubit extends MockCubit<MoviePopularState> implements MoviePopularCubit {}
void main() {

  late MoviePopularCubit moviePopularCubit;

  setUp(() {
    moviePopularCubit = MockedMoviePopularCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MoviePopularCubit>(
      create: (_) => moviePopularCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

	group('MoviePopularPageTest', () {

		testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {

			// Rearrange
			const mockedState = MoviePopularState(
				message: "",
				popularMoviesState: RequestState.Loading,
				popularMovies: <Movie>[],
			);
			when(() => moviePopularCubit.state).thenReturn(mockedState);
			when(() => moviePopularCubit.fetchPopularMovies())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

			// Expect
			final progressBarFinder = find.byType(CircularProgressIndicator);
			final centerFinder = find.byType(Center);
			expect(centerFinder, findsOneWidget);
			expect(progressBarFinder, findsOneWidget);
		});

		testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {

			// Rearrange
			MoviePopularState mockedState = MoviePopularState(
				message: "",
				popularMoviesState: RequestState.Loaded,
				popularMovies: mockedMovieList,
			);
			mockedState.copyWith(popularMovies: mockedMovieList);
			when(() => moviePopularCubit.state).thenReturn(mockedState);
			when(() => moviePopularCubit.fetchPopularMovies())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

			// Expect
			final listViewFinder = find.byType(ListView);
			expect(listViewFinder, findsOneWidget);
			expect(find.byType(MovieCard), findsNWidgets(mockedMovieList.length));
		});

		testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
			// Rearrange
			final mockedState = MoviePopularState(
				message: 'Error message',
				popularMoviesState: RequestState.Error,
				popularMovies: [mockedMovie],
			);
			when(() => moviePopularCubit.state).thenReturn(mockedState);
			when(() => moviePopularCubit.fetchPopularMovies())
				.thenAnswer((_) async => const Left(ServerFailure('Error message')));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

			// Expect
			final textFinder = find.byKey(const Key('error_message'));
			expect(textFinder, findsOneWidget);
		});

	});

}