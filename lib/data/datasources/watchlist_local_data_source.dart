import 'package:core/utils/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/watchlist_table.dart';

abstract class WatchlistLocalDataSource {
  Future<String> insertMovieWatchlist(WatchlistTable watchlist);
  Future<String> insertTVWatchlist(WatchlistTable watchlist);
  Future<String> removeWatchlist(int id);
  Future<WatchlistTable?> getWatchlistById(int id);
  Future<List<WatchlistTable>> getWatchlists();
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final DatabaseHelper databaseHelper;

  WatchlistLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertMovieWatchlist(WatchlistTable movie) async {
    try {
      await databaseHelper.insertMovieWatchlist(movie);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> insertTVWatchlist(WatchlistTable tv) async {
    try {
      await databaseHelper.insertTVWatchlist(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(int id) async {
    try {
      await databaseHelper.removeWatchlist(id);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<WatchlistTable?> getWatchlistById(int id) async {
    final result = await databaseHelper.getWatchlistById(id);
    if (result != null) {
      return WatchlistTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<WatchlistTable>> getWatchlists() async {
    final result = await databaseHelper.getWatchlists();
    return result.map((data) => WatchlistTable.fromMap(data)).toList();
  }
}
