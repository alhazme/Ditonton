import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/watchlist_repository.dart';

class GetWatchlists {
  final WatchlistRepository _repository;

  GetWatchlists(this._repository);

  Future<Either<Failure, List<Watchlist>>> execute() {
    return _repository.getWatchlists();
  }
}
