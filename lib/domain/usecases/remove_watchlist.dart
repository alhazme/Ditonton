import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:ditonton/domain/repositories/watchlist_repository.dart';

class RemoveWatchlist {
  final WatchlistRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(int id) {
    return repository.removeWatchlist(id);
  }
}
