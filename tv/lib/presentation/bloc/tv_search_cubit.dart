import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:tv/presentation/bloc/tv_search_state.dart';

class TVSearchCubit extends Cubit<TVSearchState> {

  final SearchTVs searchTVs;

  TVSearchCubit({
    required this.searchTVs,
  }) : super(
      const TVSearchState(
        message: "",
        state: RequestState.Empty,
        searchResult: <TV>[],
      )
  );

  Future<void> fetchTVSearch(String query) async {
    emit(
        state.copyWith(
          message: "",
          state: RequestState.Loading,
          searchResult: <TV>[],
        )
    );
    final result = await searchTVs.execute(query);
    result.fold(
          (failure) {
        emit(
            state.copyWith(
                message: failure.message,
                state: RequestState.Error
            )
        );
      },
          (tvsData) {
        emit(
            state.copyWith(
                state: RequestState.Loaded,
                searchResult: tvsData
            )
        );
      },
    );
  }

}