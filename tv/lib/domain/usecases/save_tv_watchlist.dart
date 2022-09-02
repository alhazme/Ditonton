import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/repositories/watchlist_repository.dart';

class SaveTVWatchlist {
  final WatchlistRepository repository;

  SaveTVWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TVDetail tv) {
    return repository.saveTVWatchlist(tv);
  }
}