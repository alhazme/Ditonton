import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/repositories/watchlist_repository.dart';

class SaveTVWatchlist {
  final WatchlistRepository repository;

  SaveTVWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TVDetail tv) {
    return repository.saveTVWatchlist(tv);
  }
}