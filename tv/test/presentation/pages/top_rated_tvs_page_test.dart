/*
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:core/utils/state_enum.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../tv/test/presentation/pages/top_rated_tvs_page_test.mocks.dart';

@GenerateMocks([TopRatedTVsNotifier])
void main() {
  late MockTopRatedTVsNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTopRatedTVsNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TopRatedTVsNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(mockNotifier.state).thenReturn(RequestState.Loading);

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTVsPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
      });

  testWidgets('Page should display when data is loaded',
          (WidgetTester tester) async {
        when(mockNotifier.state).thenReturn(RequestState.Loaded);
        when(mockNotifier.tvs).thenReturn([mockedTV]);

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTVsPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(mockNotifier.state).thenReturn(RequestState.Error);
        when(mockNotifier.message).thenReturn('Error message');

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedTVsPage()));

        expect(textFinder, findsOneWidget);
      });

}
*/