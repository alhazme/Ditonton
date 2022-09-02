import 'package:ditonton/domain/repositories/watchlist_repository.dart';

class GetWatchListStatus {
  final WatchlistRepository repository;

  GetWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
