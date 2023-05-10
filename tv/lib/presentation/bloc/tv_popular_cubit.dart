import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/presentation/bloc/tv_popular_state.dart';

class TVPopularCubit extends Cubit<TVPopularState> {

  final GetPopularTVs getPopularTVs;

  TVPopularCubit({
    required this.getPopularTVs,
  }) : super(
      const TVPopularState(
        message: "",
        popularTVsState: RequestState.Empty,
        popularTVs: <TV>[],
      )
  );

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
}
