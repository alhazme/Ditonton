import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/presentation/bloc/tv_popular_cubit.dart';
import 'package:tv/presentation/bloc/tv_popular_state.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_popular_cubit_test.mocks.dart';

@GenerateMocks([
  GetPopularTVs,
])
void main() {
  late TVPopularCubit tvPopularCubit;
  late TVPopularState tvPopularState;
  late MockGetPopularTVs mockGetPopularTVs;

  final tId = 1;

  setUp(() {
    mockGetPopularTVs = MockGetPopularTVs();
    tvPopularCubit = TVPopularCubit(
        getPopularTVs: mockGetPopularTVs
    );
    tvPopularState = TVPopularState(
      message: "",
      popularTVsState: RequestState.Empty,
      popularTVs: <TV>[],
    );
  });

  test('Initial state should be equal to default TVPopularState', () {
    expect(tvPopularCubit.state, tvPopularState);
  });

  blocTest<TVPopularCubit, TVPopularState>(
    'Should emit error when fetchPopularTVs is error',
    build: () {
      when(mockGetPopularTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('failed fetchPopularTVs')));
      return tvPopularCubit;
    },
    act: (cubit) => cubit.fetchPopularTVs(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      TVPopularState(
        message: '',
        popularTVsState: RequestState.Loading,
        popularTVs: <TV>[],
      ),
      TVPopularState(
        message: 'failed fetchPopularTVs',
        popularTVsState: RequestState.Error,
        popularTVs: <TV>[],
      ),
    ],
  );

  blocTest<TVPopularCubit, TVPopularState>(
    'Should emit success when fetchPopularTVs is success',
    build: () {
      when(mockGetPopularTVs.execute())
          .thenAnswer((_) async => Right(mockedTVList));
      return tvPopularCubit;
    },
    act: (cubit) => cubit.fetchPopularTVs(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      TVPopularState(
        message: '',
        popularTVsState: RequestState.Loading,
        popularTVs: <TV>[],
      ),
      TVPopularState(
        message: '',
        popularTVsState: RequestState.Loaded,
        popularTVs: mockedTVList,
      ),
    ],
  );
}