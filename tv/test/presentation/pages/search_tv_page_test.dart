import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_search_cubit.dart';
import 'package:tv/presentation/bloc/tv_search_state.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';
import 'package:tv/presentation/widgets/tv_card.dart';

import '../../dummy_data/dummy_objects.dart';


class MockedTVSearchCubit extends MockCubit<TVSearchState> implements TVSearchCubit {}
void main() {

  late TVSearchCubit tvSearchCubit;

  setUp(() {
    tvSearchCubit = MockedTVSearchCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TVSearchCubit>(
      create: (_) => tvSearchCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

	group('TVSearchPageTest', () {

		testWidgets('Page should display progress bar when loading', (WidgetTester tester) async {

			// Rearrange
			const mockedState = TVSearchState(
				message: "",
				state: RequestState.Loading,
				searchResult: <TV>[],
			);
			when(() => tvSearchCubit.state).thenReturn(mockedState);

			// Act
			await tester.pumpWidget(_makeTestableWidget(const SearchTVPage()));

			// Expect
			final progressFinder = find.byType(CircularProgressIndicator);
			expect(progressFinder, findsOneWidget);
		});

		testWidgets('Page should call fetchTVSearch when search textfield filled by text', (WidgetTester tester) async {

			// Rearrange
			TVSearchState mockedState = TVSearchState(
				message: "",
				state: RequestState.Loaded,
				searchResult: mockedTVList,
			);
			mockedState.copyWith(searchResult: mockedTVList);
			when(() => tvSearchCubit.state).thenReturn(mockedState);
			when(() => tvSearchCubit.fetchTVSearch('pokemon'))
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const SearchTVPage()));
			final formSearch = find.byType(TextField);
			await tester.enterText(formSearch, 'pokemon');
			await tester.testTextInput.receiveAction(TextInputAction.done);
			await tester.pump(const Duration(seconds: 3));

			// Expect
			verify(() => tvSearchCubit.fetchTVSearch('pokemon')).called(1);
    	final listViewFinder = find.byType(ListView);
			expect(listViewFinder, findsOneWidget);
			expect(find.byType(TVCard), findsNWidgets(mockedTVList.length));
		});

		testWidgets('Page should display list tv when loaded', (WidgetTester tester) async {

			// Rearrange
			TVSearchState mockedState = const TVSearchState(
				message: "",
				state: RequestState.Loaded,
				searchResult: <TV>[],
			);
			mockedState.copyWith(searchResult: mockedTVList);
			when(() => tvSearchCubit.state).thenReturn(mockedState);
			when(() => tvSearchCubit.fetchTVSearch(''))
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const SearchTVPage()));

			// Expect
			final containerFinder = find.byKey(const Key('loaded_container'));
			expect(containerFinder, findsOneWidget);
		});

		testWidgets('Page should display container when empty', (WidgetTester tester) async {

			// Rearrange
			const mockedState = TVSearchState(
				message: "",
				state: RequestState.Empty,
				searchResult: <TV>[],
			);
			when(() => tvSearchCubit.state).thenReturn(mockedState);
			
			// Act
			await tester.pumpWidget(_makeTestableWidget(const SearchTVPage()));

			// Expect
			final containerFinder = find.byType(Container);
			expect(containerFinder, findsOneWidget);
		});
	});
	
}