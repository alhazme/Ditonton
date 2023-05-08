import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/tv_detail_state.dart';
import 'package:tv/domain/usecases/save_tv_watchlist.dart';

class TVDetailCubit extends Cubit<TVDetailState> {
  
  final GetTVDetail getTVDetail;
  final GetTVRecommendations getTVRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveTVWatchlist saveTVWatchlist;
  final RemoveWatchlist removeWatchlist;

  TVDetailCubit({
    required this.getTVDetail,
    required this.getTVRecommendations,
    required this.getWatchListStatus,
    required this.saveTVWatchlist,
    required this.removeWatchlist,
  }) : super(
      const TVDetailState(
          message: "",
          tvDetailState: RequestState.Empty,
          tvDetail: null,
          tvRecommendationsState: RequestState.Empty,
          tvRecommendations: <TV>[],
          isAddedtoWatchlist: false,
          watchlistMessage: ""
      )
  );

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  Future<void> fetchTVDetail(int id) async {
    emit(
        state.copyWith(
            tvDetailState: RequestState.Loading
        )
    );
    final result = await getTVDetail.execute(id);
    final recommendationResult = await getTVRecommendations.execute(id);
    final watchListStatusResult = await getWatchListStatus.execute(id);
    result.fold(
          (failure) {
        emit(
            state.copyWith(
              message: failure.message,
              tvDetailState: RequestState.Error,
            )
        );
      },
          (tvDetailData) {
        emit(
            state.copyWith(
                message: "",
                tvDetailState: RequestState.Loaded,
                tvDetail: tvDetailData,
                tvRecommendations: <TV>[],
                isAddedtoWatchlist: watchListStatusResult
            )
        );
        recommendationResult.fold(
                (tvRecommendationsFailure) {
              emit(
                  state.copyWith(
                    message: tvRecommendationsFailure.message,
                    tvRecommendationsState: RequestState.Error,
                    tvRecommendations: <TV>[],
                    isAddedtoWatchlist: watchListStatusResult,
                  )
              );
            },
                (tvRecommendationsData) {
              emit(
                  state.copyWith(
                      tvRecommendationsState: RequestState.Loaded,
                      tvRecommendations: tvRecommendationsData,
                      isAddedtoWatchlist: watchListStatusResult
                  )
              );
            }
        );
      },
    );
  }

  Future<void> addWatchlist(TVDetail tvDetail) async {
    final result = await saveTVWatchlist.execute(tvDetail);
    result.fold(
            (failure) {
          emit(
              state.copyWith(
                isAddedtoWatchlist: false,
                watchlistMessage: failure.message,
              )
          );
        },
            (watchlistMessageData) {
          emit(
              state.copyWith(
                isAddedtoWatchlist: true,
                watchlistMessage: watchlistMessageData,
              )
          );
        }
    );
  }

  Future<void> removeFromWatchlist(int id) async {
    final result = await removeWatchlist.execute(id);
    result.fold(
            (failure) {
          emit(
              state.copyWith(
                isAddedtoWatchlist: true,
                watchlistMessage: failure.message,
              )
          );
        },
            (watchlistMessageData) {
          emit(
              state.copyWith(
                isAddedtoWatchlist: false,
                watchlistMessage: watchlistMessageData,
              )
          );
        }
    );
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(state.copyWith(isAddedtoWatchlist: result));
  }
}