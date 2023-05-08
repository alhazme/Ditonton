import 'package:core/utils/exception.dart';
import 'package:core/data/datasources/watchlist_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = WatchlistLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save movie watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertMovieWatchlist(mockedMovieWatchlistTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertMovieWatchlist(mockedMovieWatchlistTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertMovieWatchlist(mockedMovieWatchlistTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertMovieWatchlist(mockedMovieWatchlistTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('save tv watchlist', () {
    test('should return success message when insert to database is success',
            () async {
          // arrange
          when(mockDatabaseHelper.insertTVWatchlist(mockedTVWatchlistTable))
              .thenAnswer((_) async => 1);
          // act
          final result = await dataSource.insertTVWatchlist(mockedTVWatchlistTable);
          // assert
          expect(result, 'Added to Watchlist');
        });

    test('should throw DatabaseException when insert to database is failed',
            () async {
          // arrange
          when(mockDatabaseHelper.insertTVWatchlist(mockedTVWatchlistTable))
              .thenThrow(Exception());
          // act
          final call = dataSource.insertTVWatchlist(mockedTVWatchlistTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(mockedMovie.id))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeWatchlist(mockedMovie.id);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(mockedMovie.id))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlist(mockedMovie.id);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get watchlist Movie / TV Detail By Id', () {
    const tId = 1;

    test('should return Movie Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistById(tId))
          .thenAnswer((_) async => mockedMovieMap);
      // act
      final result = await dataSource.getWatchlistById(tId);
      // assert
      expect(result, mockedMovieWatchlistTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getWatchlistById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlists', () {
    test('should return list of watchlist movie / tv from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlists())
          .thenAnswer((_) async => [mockedMovieMap, mockedTVMap]);
      // act
      final result = await dataSource.getWatchlists();
      // assert
      expect(result, [mockedMovieWatchlistTable, mockedTVWatchlistTable]);
    });
  });
}
