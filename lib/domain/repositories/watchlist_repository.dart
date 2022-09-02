import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/watchlist.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, String>> saveMovieWatchlist(MovieDetail movie);
  Future<Either<Failure, String>> saveTVWatchlist(TVDetail tv);
  Future<Either<Failure, String>> removeWatchlist(int id);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Watchlist>>> getWatchlists();
}
