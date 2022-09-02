import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/watchlist.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, String>> saveMovieWatchlist(MovieDetail movie);
  Future<Either<Failure, String>> saveTVWatchlist(TVDetail tv);
  Future<Either<Failure, String>> removeWatchlist(int id);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Watchlist>>> getWatchlists();
}
