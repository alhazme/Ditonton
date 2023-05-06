import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_popular_cubit.dart';
import 'package:tv/presentation/bloc/tv_popular_state.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:tv/presentation/widgets/tv_card.dart';

import '../../dummy_data/dummy_objects.dart';

class MockedTVPopularCubit extends MockCubit<TVPopularState> implements TVPopularCubit {}
void main() {

  late TVPopularCubit tvPopularCubit;

  setUp(() {
    tvPopularCubit = MockedTVPopularCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TVPopularCubit>(
      create: (_) => tvPopularCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

	group('TVPopularPageTest', () {

		testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {

			// Rearrange
			const mockedState = TVPopularState(
				message: "",
				popularTVsState: RequestState.Loading,
				popularTVs: <TV>[],
			);
			when(() => tvPopularCubit.state).thenReturn(mockedState);
			when(() => tvPopularCubit.fetchPopularTVs())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const PopularTvsPage()));

			// Expect
			final progressBarFinder = find.byType(CircularProgressIndicator);
			final centerFinder = find.byType(Center);
			expect(centerFinder, findsOneWidget);
			expect(progressBarFinder, findsOneWidget);
		});

		testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {

			// Rearrange
			TVPopularState mockedState = TVPopularState(
				message: "",
				popularTVsState: RequestState.Loaded,
				popularTVs: mockedTVList,
			);
			mockedState.copyWith(popularTVs: mockedTVList,);
			when(() => tvPopularCubit.state).thenReturn(mockedState);
			when(() => tvPopularCubit.fetchPopularTVs())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const PopularTvsPage()));

			// Expect
			final listViewFinder = find.byType(ListView);
			expect(listViewFinder, findsOneWidget);
			expect(find.byType(TVCard), findsNWidgets(mockedTVList.length));
		});

		testWidgets('Page should display text with message when Error', (WidgetTester tester) async {
			// Rearrange
			final mockedState = TVPopularState(
				message: 'Error message',
				popularTVsState: RequestState.Error,
				popularTVs: mockedTVList,
			);
			when(() => tvPopularCubit.state).thenReturn(mockedState);
			when(() => tvPopularCubit.fetchPopularTVs())
				.thenAnswer((_) async => Left(ServerFailure('Error message')));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const PopularTvsPage()));

			// Expect
			final textFinder = find.byKey(const Key('error_message'));
			expect(textFinder, findsOneWidget);
		});

	});

}