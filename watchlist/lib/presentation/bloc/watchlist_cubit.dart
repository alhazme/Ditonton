import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:watchlist/domain/usecases/get_watchlists.dart';
import 'package:watchlist/presentation/bloc/watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {

  final GetWatchlists getWatchlists;

  WatchlistCubit({
    required this.getWatchlists,
  }) : super(
      WatchlistState(
        message: "",
        watchlistState: RequestState.Empty,
        watchlists: <Watchlist>[],
      )
  );

  Future<void> fetchWatchlists() async {
    emit(
        state.copyWith(
            watchlistState: RequestState.Loading
        )
    );
    final result = await getWatchlists.execute();
    result.fold(
      (failure) {
        emit(
            state.copyWith(
                message: failure.message,
                watchlistState: RequestState.Error
            )
        );
      },
      (watchlistsData) {
        emit(
            state.copyWith(
                watchlistState: RequestState.Loaded,
                watchlists: watchlistsData
            )
        );
      },
    );
  }
}
