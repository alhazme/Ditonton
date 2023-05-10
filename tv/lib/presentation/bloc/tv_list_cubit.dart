import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/tv_list_state.dart';

class TVListCubit extends Cubit<TVListState> {

  final GetNowPlayingTVs getNowPlayingTVs;
  final GetPopularTVs getPopularTVs;
  final GetTopRatedTVs getTopRatedTVs;

  TVListCubit({
    required this.getNowPlayingTVs,
    required this.getPopularTVs,
    required this.getTopRatedTVs,
  }) : super(
      const TVListState(
          message: "",
          nowPlayingTVState: RequestState.Empty,
          nowPlayingTVs: <TV>[],
          popularTVsState: RequestState.Empty,
          popularTVs: <TV>[],
          topRatedTVsState: RequestState.Empty,
          topRatedTVs: <TV>[]
      )
  );

  Future<void> fetchNowPlayingTVs() async {
    emit(
        state.copyWith(
            nowPlayingTVState: RequestState.Loading
        )
    );
    final result = await getNowPlayingTVs.execute();
    result.fold(
          (failure) {
        emit(
            state.copyWith(
                message: failure.message,
                nowPlayingTVState: RequestState.Error
            )
        );
      },
          (tvsData) {
        emit(
            state.copyWith(
                nowPlayingTVState: RequestState.Loaded,
                nowPlayingTVs: tvsData
            )
        );
      },
    );
  }

  Future<void> fetchPopularTVs() async {
    emit(
        state.copyWith(
            popularTVsState: RequestState.Loading
        )
    );
    final result = await getPopularTVs.execute();
    result.fold(
          (failure) {
        emit(
            state.copyWith(
                message: failure.message,
                popularTVsState: RequestState.Error
            )
        );
      },
          (tvsData) {
        emit(
            state.copyWith(
                popularTVsState: RequestState.Loaded,
                popularTVs: tvsData
            )
        );
      },
    );
  }

  Future<void> fetchTopRatedTVs() async {
    emit(
        state.copyWith(
            topRatedTVsState: RequestState.Loading
        )
    );
    final result = await getTopRatedTVs.execute();
    result.fold(
          (failure) {
        emit(
            state.copyWith(
                message: failure.message,
                topRatedTVsState: RequestState.Error
            )
        );
      },
          (tvsData) {
        emit(
            state.copyWith(
                topRatedTVsState: RequestState.Loaded,
                topRatedTVs: tvsData
            )
        );
      },
    );
  }
}
