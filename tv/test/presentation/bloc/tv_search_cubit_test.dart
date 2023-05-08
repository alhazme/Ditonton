import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:tv/presentation/bloc/tv_search_cubit.dart';
import 'package:tv/presentation/bloc/tv_search_state.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_search_cubit_test.mocks.dart';

@GenerateMocks([
  SearchTVs,
])
void main() {
  late TVSearchCubit tvSearchCubit;
  late TVSearchState tvSearchState;
  late MockSearchTVs mockSearchTVs;

  setUp(() {
    mockSearchTVs = MockSearchTVs();
    tvSearchCubit = TVSearchCubit(
        searchTVs: mockSearchTVs
    );
    tvSearchState = const TVSearchState(
      message: "",
      state: RequestState.Empty,
      searchResult: <TV>[],
    );
  });

  test('Initial state should be equal to default TVSearchState', () {
    expect(tvSearchCubit.state, tvSearchState);
  });

  blocTest<TVSearchCubit, TVSearchState>(
    'Should emit error when fetchTVSearch is error',
    build: () {
      when(mockSearchTVs.execute('dragonball'))
          .thenAnswer((_) async => const Left(ServerFailure('failed fetchTVSearch')));
      return tvSearchCubit;
    },
    act: (cubit) => cubit.fetchTVSearch('dragonball'),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const TVSearchState(
        message: '',
        state: RequestState.Loading,
        searchResult: <TV>[],
      ),
      const TVSearchState(
        message: 'failed fetchTVSearch',
        state: RequestState.Error,
        searchResult: <TV>[],
      ),
    ],
  );

  blocTest<TVSearchCubit, TVSearchState>(
    'Should emit success when fetchTVSearch is success',
    build: () {
      when(mockSearchTVs.execute('dragonball'))
          .thenAnswer((_) async => Right(mockedTVList));
      return tvSearchCubit;
    },
    act: (cubit) => cubit.fetchTVSearch('dragonball'),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const TVSearchState(
        message: '',
        state: RequestState.Loading,
        searchResult: <TV>[],
      ),
      TVSearchState(
        message: '',
        state: RequestState.Loaded,
        searchResult: mockedTVList,
      ),
    ],
  );
}