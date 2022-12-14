import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:watchlist/domain/usecases/get_watchlists.dart';
import 'package:watchlist/presentation/provider/watchlist_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_notifier_test.mocks.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';

@GenerateMocks([GetWatchlists])
void main() {
  late WatchlistNotifier provider;
  late MockGetWatchlists mockGetWatchList;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchList = MockGetWatchlists();
    provider = WatchlistNotifier(getWatchlists: mockGetWatchList)
    ..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetWatchList.execute())
        .thenAnswer((_) async => Right(mockedWatchlists));
    // act
    await provider.fetchWatchlists();
    // assert
    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlists, mockedWatchlists);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchList.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlists();
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
