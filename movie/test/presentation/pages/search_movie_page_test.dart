import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_search_cubit.dart';
import 'package:movie/presentation/bloc/movie_search_state.dart';
import 'package:movie/presentation/pages/search_movie_page.dart';
import 'package:movie/presentation/widget/movie_card.dart';

import '../../dummy_data/dummy_objects.dart';


class MockedMovieSearchCubit extends MockCubit<MovieSearchState> implements MovieSearchCubit {}
void main() {

  late MovieSearchCubit movieSearchCubit;

  setUp(() {
    movieSearchCubit = MockedMovieSearchCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieSearchCubit>(
      create: (_) => movieSearchCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

	group('MovieSearchPageTest', () {

		testWidgets('Page should display progress bar when loading', (WidgetTester tester) async {

			// Rearrange
			const mockedState = MovieSearchState(
				message: "",
				state: RequestState.Loading,
				searchResult: <Movie>[],
			);
			when(() => movieSearchCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));

			// Expect
			final progressFinder = find.byType(CircularProgressIndicator);
			expect(progressFinder, findsOneWidget);
		});

		testWidgets('Page should call fetchMovieSearch when search textfield filled by text', (WidgetTester tester) async {

			// Rearrange
			MovieSearchState mockedState = MovieSearchState(
				message: "",
				state: RequestState.Loaded,
				searchResult: mockedMovieList,
			);
			mockedState.copyWith(searchResult: mockedMovieList);
			when(() => movieSearchCubit.state).thenReturn(mockedState);
			when(() => movieSearchCubit.fetchMovieSearch('pokemon'))
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));
			final formSearch = find.byType(TextField);
			await tester.enterText(formSearch, 'pokemon');
			await tester.testTextInput.receiveAction(TextInputAction.done);
			await tester.pump(const Duration(seconds: 3));

			// Expect
			verify(() => movieSearchCubit.fetchMovieSearch('pokemon')).called(1);
    	final listViewFinder = find.byType(ListView);
			expect(listViewFinder, findsOneWidget);
			expect(find.byType(MovieCard), findsNWidgets(mockedMovieList.length));
		});

		testWidgets('Page should display list movie when loaded', (WidgetTester tester) async {

			// Rearrange
			MovieSearchState mockedState = const MovieSearchState(
				message: "",
				state: RequestState.Loaded,
				searchResult: <Movie>[],
			);
			mockedState.copyWith(searchResult: mockedMovieList);
			when(() => movieSearchCubit.state).thenReturn(mockedState);
			when(() => movieSearchCubit.fetchMovieSearch(''))
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));

			// Expect
			final containerFinder = find.byKey(const Key('loaded_container'));
			expect(containerFinder, findsOneWidget);
		});

		testWidgets('Page should display container when empty', (WidgetTester tester) async {

			// Rearrange
			const mockedState = MovieSearchState(
				message: "",
				state: RequestState.Empty,
				searchResult: <Movie>[],
			);
			when(() => movieSearchCubit.state).thenReturn(mockedState);
			// when(() => movieSearchCubit.fetchMovieSearch(''))
			// 	.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const SearchMoviePage()));

			// Expect
			final containerFinder = find.byType(Container);
			expect(containerFinder, findsOneWidget);
		});
	});
	
}