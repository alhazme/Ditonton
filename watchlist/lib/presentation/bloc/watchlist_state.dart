import 'package:core/domain/entities/watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class WatchlistState extends Equatable {

  final String message;
  final RequestState watchlistState;
  final List<Watchlist> watchlists;

  const WatchlistState({
    this.message = "",
    this.watchlistState = RequestState.Empty,
    this.watchlists = const <Watchlist>[],
  });

  WatchlistState copyWith({
    String? message,
    RequestState? watchlistState,
    List<Watchlist>? watchlists,
  }) {
    return WatchlistState(
      message: message ?? this.message,
      watchlistState: watchlistState ?? this.watchlistState,
      watchlists: watchlists ?? this.watchlists,
    );
  }

  @override
  List<Object> get props => [
    message,
    watchlistState,
    watchlists,
  ];

}