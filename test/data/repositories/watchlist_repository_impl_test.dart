import 'package:dartz/dartz.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:ditonton/data/repositories/watchlist_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistRepositoryImpl repository;
  late MockWatchlistLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockWatchlistLocalDataSource();
    repository = WatchlistRepositoryImpl(
        watchlistLocalDataSource: mockLocalDataSource
    );
  });

  group('save movie watchlist', () {
    test('should return success message when movie saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertMovieWatchlist(mockedMovieWatchlistTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveMovieWatchlist(mockedMovieDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertMovieWatchlist(mockedMovieWatchlistTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveMovieWatchlist(mockedMovieDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('save tv watchlist', () {
    test('should return success message when tv saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertTVWatchlist(mockedTVWatchlistTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveTVWatchlist(mockedTVDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });
    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertTVWatchlist(mockedTVWatchlistTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveTVWatchlist(mockedTVDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.removeWatchlist(tId))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(tId);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.removeWatchlist(tId))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(tId);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getWatchlistById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockLocalDataSource.getWatchlists())
          .thenAnswer((_) async => [mockedMovieWatchlistTable, mockedTVWatchlistTable]);
      // act
      final result = await repository.getWatchlists();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [mockedWatchlistMovie, mockedWatchlistTV]);
    });
  });
}