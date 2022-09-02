import 'package:dartz/dartz.dart';
import 'package:ditonton/data/datasources/watchlist_local_data_source.dart';
import 'package:ditonton/data/models/watchlist_table.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/domain/repositories/watchlist_repository.dart';

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
