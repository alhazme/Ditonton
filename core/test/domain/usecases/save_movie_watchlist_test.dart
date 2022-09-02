import 'package:dartz/dartz.dart';
import 'package:core/domain/usecases/save_movie_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

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
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(mockedMovieDetail);
    // assert
    verify(mockWatchlistRepository.saveMovieWatchlist(mockedMovieDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
