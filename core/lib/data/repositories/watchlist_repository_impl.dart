import 'package:dartz/dartz.dart';
import 'package:core/data/datasources/watchlist_local_data_source.dart';
import 'package:core/data/models/watchlist_table.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/watchlist.dart';
import 'package:core/domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource watchlistLocalDataSource;

  WatchlistRepositoryImpl({
    required this.watchlistLocalDataSource,
  });

  @override
  Future<Either<Failure, String>> saveMovieWatchlist(MovieDetail movie) async {
    try {
      final result = await watchlistLocalDataSource.insertMovieWatchlist(WatchlistTable.fromMovieDetailEntity(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> saveTVWatchlist(TVDetail tv) async {
    try {
      final result = await watchlistLocalDataSource.insertTVWatchlist(WatchlistTable.fromTvDetailEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(int id) async {
    try {
      final result =
      await watchlistLocalDataSource.removeWatchlist(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await watchlistLocalDataSource.getWatchlistById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Watchlist>>> getWatchlists() async {
    final result = await watchlistLocalDataSource.getWatchlists();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}
