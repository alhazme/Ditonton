import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/watchlist.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/repositories/watchlist_repository.dart';

class GetWatchlists {
  final WatchlistRepository _repository;

  GetWatchlists(this._repository);

  Future<Either<Failure, List<Watchlist>>> execute() {
    return _repository.getWatchlists();
  }
}
