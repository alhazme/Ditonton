import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlist usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = RemoveWatchlist(mockWatchlistRepository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    const tId = 1;
    when(mockWatchlistRepository.removeWatchlist(tId))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(tId);
    // assert
    verify(mockWatchlistRepository.removeWatchlist(tId));
    expect(result, const Right('Removed from watchlist'));
  });
}
