import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:core/utils/state_enum.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TVDetailNotifier])
void main() {
  late MockTVDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  // TV

  testWidgets(
      'show CircularProgressIndicator when tvs still loading from server',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loading);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loading);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);

        await tester.pumpWidget(
            _makeTestableWidget(TVDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets(
      'should display error text when failed to retrieve tv data',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Error);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.message).thenReturn('Failed');

        await tester.pumpWidget(
            _makeTestableWidget(TVDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.text('Failed'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(TVDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display check icon when tv is added to wathclist',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(true);

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(TVDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(TVDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.watchlistMessage).thenReturn('Failed');

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(TVDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(true);
        when(mockNotifier.watchlistMessage).thenReturn('Removed from Watchlist');

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(TVDetailPage(id: 1)));

        expect(find.byIcon(Icons.check), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Removed from Watchlist'), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(true);
        when(mockNotifier.watchlistMessage).thenReturn('Failed');

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(TVDetailPage(id: 1)));

        expect(find.byIcon(Icons.check), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Failed'), findsOneWidget);
      });

  // Recommendations

  testWidgets(
      'show CircularProgressIndicator when tvs still loading from server',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loading);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        const testKey = Key('tv_recommendations_loading');

        await tester.pumpWidget(
            _makeTestableWidget(TVDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.byKey(testKey), findsOneWidget);
      });

  testWidgets(
      'should display error text when failed to retrieve tv recommendations data',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.message).thenReturn('Failed retrieve tv recommendations');

        await tester.pumpWidget(
            _makeTestableWidget(TVDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.text('Failed retrieve tv recommendations'), findsOneWidget);
      });

  testWidgets(
      'should display error text when empty to retrieve tv recommendations data',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Empty);
        when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        when(mockNotifier.message).thenReturn('Failed');
        const testKey = Key('tv_recommendations_empty');
        await tester.pumpWidget(
            _makeTestableWidget(TVDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.byKey(testKey), findsOneWidget);
      });

  testWidgets(
      'show tvs recommendation when tvs loaded from server',
          (WidgetTester tester) async {
        when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tv).thenReturn(mockedTVDetail);
        when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvRecommendations).thenReturn([mockedTV]);
        when(mockNotifier.isAddedToWatchlist).thenReturn(false);
        const testKey = Key('tv_recommendations_loaded_image');

        await tester.pumpWidget(
            _makeTestableWidget(TVDetailPage(id: 1)),
            Duration(seconds: 3)
        );

        expect(find.byKey(testKey), findsOneWidget);
      });
}