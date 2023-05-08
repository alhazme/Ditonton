import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/save_movie_watchlist.dart';
import 'package:movie/presentation/bloc/movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveMovieWatchlist saveMovieWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailCubit({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveMovieWatchlist,
    required this.removeWatchlist,
  }) : super(
      MovieDetailState(
        message: "",
        movieDetailState: RequestState.Empty,
        movieDetail: null,
        movieRecommendationsState: RequestState.Empty,
        movieRecommendations: const <Movie>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ""
      )
  );

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  Future<void> fetchMovieDetail(int id) async {
    emit(
      state.copyWith(
        movieDetailState: RequestState.Loading
      )
    );
    final result = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);
    final watchListStatusResult = await getWatchListStatus.execute(id);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            message: failure.message,
            movieDetailState: RequestState.Error,
          )
        );
      },
      (movieDetailData) {
        emit(
          state.copyWith(
            message: "",
            movieDetailState: RequestState.Loaded,
            movieDetail: movieDetailData,
            movieRecommendations: <Movie>[],
            isAddedtoWatchlist: watchListStatusResult
          )
        );
        recommendationResult.fold(
          (movieRecommendationsFailure) {
            emit(
              state.copyWith(
                message: movieRecommendationsFailure.message,
                movieRecommendationsState: RequestState.Error,
                movieRecommendations: <Movie>[],
                isAddedtoWatchlist: watchListStatusResult,
              )
            );
          },
          (movieRecommendationsData) {
            emit(
              state.copyWith(
                movieRecommendationsState: RequestState.Loaded,
                movieRecommendations: movieRecommendationsData,
                isAddedtoWatchlist: watchListStatusResult
              )
            );
          }
        );
      },
    );
  }

  Future<void> addWatchlist(MovieDetail movieDetail) async {
    final result = await saveMovieWatchlist.execute(movieDetail);
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
