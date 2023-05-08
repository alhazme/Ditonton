import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:watchlist/presentation/widgets/watchlist_card.dart';

void main() {
  group('Testing App', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

		testWidgets('Verify movie watchlist', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // click movie item
      final movieItem = find.byKey(Key('movie_item')).first;
      await tester.tap(movieItem);
      await tester.pumpAndSettle();

      // click watchlist button
			final watchlistButton = find.byKey(Key('watchlist_button'));
      await tester.tap(watchlistButton);
      await tester.pumpAndSettle();
			final iconCheck = find.byIcon(Icons.check);
      expect(iconCheck, findsOneWidget);

			// Back to home page
			final iconBack = find.byIcon(Icons.arrow_back);
      await tester.tap(iconBack);
      await tester.pumpAndSettle();

      // click watchlist menu in home page
    	await tester.tap(find.byTooltip('Open navigation menu'));
			await tester.pumpAndSettle();
    	final iconWatchlist = find.byIcon(Icons.save_alt);
			await tester.tap(iconWatchlist);
			await tester.pumpAndSettle();

      // check save movie item in watchlist page
      expect(find.byType(WatchlistCard), findsOneWidget);

		});

		testWidgets('Verify tv watchlist', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

			// Open drawer
			await tester.tap(find.byTooltip('Open navigation menu'));
			await tester.pumpAndSettle();

			// click tv menu on drawer
    	final iconTV = find.byIcon(Icons.tv);
			await tester.tap(iconTV);
			await tester.pumpAndSettle();

			// click tv item
      final tvItem = find.byKey(Key('tv_item')).first;
      await tester.tap(tvItem);
      await tester.pumpAndSettle();

			// click watchlist button
			final watchlistButton = find.byKey(Key('watchlist_button'));
      await tester.tap(watchlistButton);
      await tester.pumpAndSettle();
			final iconCheck = find.byIcon(Icons.check);
      expect(iconCheck, findsOneWidget);

			// Back to home page
			final iconBack = find.byIcon(Icons.arrow_back);
      await tester.tap(iconBack);
      await tester.pumpAndSettle();

      // click watchlist menu in home page
    	await tester.tap(find.byTooltip('Open navigation menu'));
			await tester.pumpAndSettle();
    	final iconWatchlist = find.byIcon(Icons.save_alt);
			await tester.tap(iconWatchlist);
			await tester.pumpAndSettle();

      // check save movie item in watchlist page
      expect(find.byType(WatchlistCard), findsOneWidget);
		});
	});
}