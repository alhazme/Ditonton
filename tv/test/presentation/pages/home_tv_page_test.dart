import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_list_cubit.dart';
import 'package:tv/presentation/bloc/tv_list_state.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockedTVListCubit extends MockCubit<TVListState> implements TVListCubit {}
class MockNavigatorObserver extends Mock implements NavigatorObserver { }

void main() {
	late TVListCubit tvListCubit;
	late MockNavigatorObserver mockObserver;

	setUp(() {
		tvListCubit = MockedTVListCubit();
		mockObserver = MockNavigatorObserver();
	});

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TVListCubit>(
      create: (_) => tvListCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

	group('TVHomePageTest', () {

		testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {

			// Rearrange
			const mockedState = TVListState(
				message: '',
				nowPlayingTVState: RequestState.Loading,
				nowPlayingTVs: <TV>[],
				popularTVsState: RequestState.Loading,
				popularTVs: <TV>[],
				topRatedTVsState: RequestState.Loading,
				topRatedTVs: <TV>[],
			);
			when(() => tvListCubit.state).thenReturn(mockedState);
			when(() => tvListCubit.fetchNowPlayingTVs())
				.thenAnswer((_) async => const Right(true));
			when(() => tvListCubit.fetchPopularTVs())
				.thenAnswer((_) async => const Right(true));
			when(() => tvListCubit.fetchTopRatedTVs())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const HomeTVPage()));

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
			final mockedState = TVListState(
				message: '',
				nowPlayingTVState: RequestState.Loaded,
				nowPlayingTVs: mockedTVList,
				popularTVsState: RequestState.Loaded,
				popularTVs: mockedTVList,
				topRatedTVsState: RequestState.Loaded,
				topRatedTVs: mockedTVList,
			);
			when(() => tvListCubit.state).thenReturn(mockedState);
			when(() => tvListCubit.fetchNowPlayingTVs())
				.thenAnswer((_) async => const Right(true));
			when(() => tvListCubit.fetchPopularTVs())
				.thenAnswer((_) async => const Right(true));
			when(() => tvListCubit.fetchTopRatedTVs())
				.thenAnswer((_) async => const Right(true));

			// Act
			await tester.pumpWidget(_makeTestableWidget(const HomeTVPage()));

			// Expect
			final nowPlayingMovieList = find.byKey(const Key('now_playing_tvs'));
			final popularMovieList = find.byKey(const Key('popular_tvs'));
			final topRatedMovieList = find.byKey(const Key('top_rated_tvs'));

			expect(nowPlayingMovieList, findsOneWidget);
			expect(popularMovieList, findsOneWidget);
			expect(topRatedMovieList, findsOneWidget);
		});
		
	});
}