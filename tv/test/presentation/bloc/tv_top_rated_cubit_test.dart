import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/tv_top_rated_cubit.dart';
import 'package:tv/presentation/bloc/tv_top_rated_state.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_top_rated_cubit_test.mocks.dart';

@GenerateMocks([
  GetTopRatedTVs,
])
void main() {
  late TVTopRatedCubit tvTopRatedCubit;
  late TVTopRatedState tvTopRatedState;
  late MockGetTopRatedTVs mockGetTopRatedTVs;

  final tId = 1;

  setUp(() {
    mockGetTopRatedTVs = MockGetTopRatedTVs();
    tvTopRatedCubit = TVTopRatedCubit(
        getTopRatedTVs: mockGetTopRatedTVs
    );
    tvTopRatedState = TVTopRatedState(
      message: "",
      topRatedTVsState: RequestState.Empty,
      topRatedTVs: <TV>[],
    );
  });

  test('Initial state should be equal to default TVTopRatedState', () {
    expect(tvTopRatedCubit.state, tvTopRatedState);
  });

  blocTest<TVTopRatedCubit, TVTopRatedState>(
    'Should emit error when fetchTopRatedTVs is error',
    build: () {
      when(mockGetTopRatedTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('failed fetchTopRatedTVs')));
      return tvTopRatedCubit;
    },
    act: (cubit) => cubit.fetchTopRatedTVs(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      TVTopRatedState(
        message: '',
        topRatedTVsState: RequestState.Loading,
        topRatedTVs: <TV>[],
      ),
      TVTopRatedState(
        message: 'failed fetchTopRatedTVs',
        topRatedTVsState: RequestState.Error,
        topRatedTVs: <TV>[],
      ),
    ],
  );

  blocTest<TVTopRatedCubit, TVTopRatedState>(
    'Should emit success when fetchTopRatedTVs is success',
    build: () {
      when(mockGetTopRatedTVs.execute())
          .thenAnswer((_) async => Right(mockedTVList));
      return tvTopRatedCubit;
    },
    act: (cubit) => cubit.fetchTopRatedTVs(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      TVTopRatedState(
        message: '',
        topRatedTVsState: RequestState.Loading,
        topRatedTVs: <TV>[],
      ),
      TVTopRatedState(
        message: '',
        topRatedTVsState: RequestState.Loaded,
        topRatedTVs: mockedTVList,
      ),
    ],
  );
}