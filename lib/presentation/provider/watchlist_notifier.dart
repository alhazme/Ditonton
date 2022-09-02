import 'package:core/utils/state_enum.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/domain/usecases/get_watchlists.dart';
import 'package:flutter/foundation.dart';

class WatchlistNotifier extends ChangeNotifier {

  // Movies
  var _watchlists = <Watchlist>[];
  List<Watchlist> get watchlists => _watchlists;
  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistNotifier({required this.getWatchlists});

  final GetWatchlists getWatchlists;

  Future<void> fetchWatchlists() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlists.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (watchlistsData) {
        _watchlistState = RequestState.Loaded;
        _watchlists = watchlistsData;
        notifyListeners();
      },
    );
  }
}
