
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_top_rated_cubit.dart';
import 'package:tv/presentation/bloc/tv_top_rated_state.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/widgets/tv_card.dart';

import '../../dummy_data/dummy_objects.dart';

class MockedTVTopRatedCubit extends MockCubit<TVTopRatedState> implements TVTopRatedCubit {}
void main() {

  late TVTopRatedCubit tvTopRatedCubit;

  setUp(() {
    tvTopRatedCubit = MockedTVTopRatedCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TVTopRatedCubit>(
      create: (_) => tvTopRatedCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

	group('TVTopRatedPageTest', () {

		testWidgets('Page should display progress bar when loading', (WidgetTester tester) async {

			// Rearrange
			const mockedState = TVTopRatedState(
				message: "",
				topRatedTVsState: RequestState.Loading,
				topRatedTVs: <TV>[],
			);
			when(() => tvTopRatedCubit.state).thenReturn(mockedState);
			when(() => tvTopRatedCubit.fetchTopRatedTVs())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const TopRatedTVsPage()));

			// Expect
			final progressFinder = find.byType(CircularProgressIndicator);
			final centerFinder = find.byType(Center);
			expect(centerFinder, findsOneWidget);
			expect(progressFinder, findsOneWidget);
		});

		testWidgets('Page should display when data is loaded', (WidgetTester tester) async {

			// Rearrange
			TVTopRatedState mockedState = TVTopRatedState(
				message: "",
				topRatedTVsState: RequestState.Loaded,
				topRatedTVs: mockedTVList,
			);
			mockedState.copyWith(topRatedTVs: mockedTVList);
			when(() => tvTopRatedCubit.state).thenReturn(mockedState);
			when(() => tvTopRatedCubit.fetchTopRatedTVs())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const TopRatedTVsPage()));

			// Expect
			final listViewFinder = find.byType(ListView);
			expect(listViewFinder, findsOneWidget);
			expect(find.byType(TVCard), findsNWidgets(mockedMovieList.length));
		});

		testWidgets('Page should display text with message when Error', (WidgetTester tester) async {

			// Rearrange
			final mockedState = TVTopRatedState(
				message: 'Error message',
				topRatedTVsState: RequestState.Error,
				topRatedTVs: mockedTVList,
			);
			when(() => tvTopRatedCubit.state).thenReturn(mockedState);
			when(() => tvTopRatedCubit.fetchTopRatedTVs())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const TopRatedTVsPage()));

			// Expect
			final textFinder = find.byKey(const Key('error_message'));
			expect(textFinder, findsOneWidget);
		});

	});

}