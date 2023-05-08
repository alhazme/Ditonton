import 'package:dartz/dartz.dart';
import 'package:tv/domain/usecases/save_tv_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

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
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(mockedTVDetail);
    // assert
    verify(mockWatchlistRepository.saveTVWatchlist(mockedTVDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
