import 'package:dartz/dartz.dart';
import 'package:movie/domain/usecases/save_movie_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late SaveMovieWatchlist usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = SaveMovieWatchlist(mockWatchlistRepository);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(mockWatchlistRepository.saveMovieWatchlist(mockedMovieDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(mockedMovieDetail);
    // assert
    verify(mockWatchlistRepository.saveMovieWatchlist(mockedMovieDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
