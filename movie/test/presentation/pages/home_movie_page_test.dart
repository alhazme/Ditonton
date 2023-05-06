import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_home_cubit.dart';
import 'package:movie/presentation/bloc/movie_home_state.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';

class MockedMovieHomeCubit extends MockCubit<MovieHomeState> implements MovieHomeCubit {}
class MockNavigatorObserver extends Mock implements NavigatorObserver { }

void main() {
	late MovieHomeCubit movieHomeCubit;
	late MockNavigatorObserver mockObserver;

	setUp(() {
		movieHomeCubit = MockedMovieHomeCubit();
		mockObserver = MockNavigatorObserver();
	});

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieHomeCubit>(
      create: (_) => movieHomeCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

	group('MovieHomePageTest', () {

		testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {

			// Rearrange
			const mockedState = MovieHomeState(
				message: '',
				nowPlayingState: RequestState.Loading,
				nowPlayingMovies: <Movie>[],
				popularMoviesState: RequestState.Loading,
				popularMovies: <Movie>[],
				topRatedMoviesState:  RequestState.Loading,
				topRatedMovies: <Movie>[]
			);
			when(() => movieHomeCubit.state).thenReturn(mockedState);
			when(() => movieHomeCubit.fetchNowPlayingMovies())
				.thenAnswer((_) async => const Right(true));
			when(() => movieHomeCubit.fetchPopularMovies())
				.thenAnswer((_) async => const Right(true));
			when(() => movieHomeCubit.fetchTopRatedMovies())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

			// Expect
			final nowPlayingProgressIndicator = find.byKey(const Key('now_playing_progress_indicator'));
			final popularProgressIndicator = find.byKey(const Key('popular_progress_indicator'));
			final topRatedProgressIndicator = find.byKey(const Key('top_rated_progress_indicator'));

			expect(nowPlayingProgressIndicator, findsOneWidget);
			expect(popularProgressIndicator, findsOneWidget);
			expect(topRatedProgressIndicator, findsOneWidget);
		});

		testWidgets('Page should display list when data loaded', (WidgetTester tester) async {

			// Rearrange
			final mockedState = MovieHomeState(
					message: '',
					nowPlayingState: RequestState.Loaded,
					nowPlayingMovies: [mockedMovie],
					popularMoviesState: RequestState.Loaded,
					popularMovies: [mockedMovie],
					topRatedMoviesState:  RequestState.Loaded,
					topRatedMovies: [mockedMovie]
			);
			when(() => movieHomeCubit.state).thenReturn(mockedState);
			when(() => movieHomeCubit.fetchNowPlayingMovies())
				.thenAnswer((_) async => const Right(true));
			when(() => movieHomeCubit.fetchPopularMovies())
				.thenAnswer((_) async => const Right(true));
			when(() => movieHomeCubit.fetchTopRatedMovies())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

			// Expect
			final nowPlayingMovieList = find.byKey(const Key('now_playing_movies'));
			final popularMovieList = find.byKey(const Key('popular_movies'));
			final topRatedMovieList = find.byKey(const Key('top_rated_movies'));

			expect(nowPlayingMovieList, findsOneWidget);
			expect(popularMovieList, findsOneWidget);
			expect(topRatedMovieList, findsOneWidget);
		});

	});

}