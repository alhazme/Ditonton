import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/tv_top_rated_state.dart';

class TVTopRatedCubit extends Cubit<TVTopRatedState> {

  final GetTopRatedTVs getTopRatedTVs;

  TVTopRatedCubit({
    required this.getTopRatedTVs,
  }) : super(
      const TVTopRatedState(
        message: "",
        topRatedTVsState: RequestState.Empty,
        topRatedTVs: <TV>[],
      )
  );

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
