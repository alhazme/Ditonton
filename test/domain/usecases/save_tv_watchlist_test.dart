import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTVWatchlist usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = SaveTVWatchlist(mockWatchlistRepository);
  });

  test('should save tv to the repository', () async {
    // arrange
    when(mockWatchlistRepository.saveTVWatchlist(mockedTVDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(mockedTVDetail);
    // assert
    verify(mockWatchlistRepository.saveTVWatchlist(mockedTVDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
