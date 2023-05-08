import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/tv_list_cubit.dart';
import 'package:tv/presentation/bloc/tv_list_state.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_list_cubit_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTVs,
  GetPopularTVs,
  GetTopRatedTVs,
])
void main() {
  late TVListCubit movieHomeCubit;
  late TVListState movieHomeState;
  late MockGetNowPlayingTVs mockGetNowPlayingTVs;
  late MockGetPopularTVs mockGetPopularTVs;
  late MockGetTopRatedTVs mockGetTopRatedTVs;

  setUp(() {
    mockGetNowPlayingTVs = MockGetNowPlayingTVs();
    mockGetPopularTVs = MockGetPopularTVs();
    mockGetTopRatedTVs = MockGetTopRatedTVs();
    movieHomeCubit = TVListCubit(
        getNowPlayingTVs: mockGetNowPlayingTVs,
        getPopularTVs: mockGetPopularTVs,
        getTopRatedTVs: mockGetTopRatedTVs
    );
    movieHomeState = const TVListState(
      message: "",
      nowPlayingTVState: RequestState.Empty,
      nowPlayingTVs: <TV>[],
      popularTVsState: RequestState.Empty,
      popularTVs: <TV>[],
      topRatedTVsState: RequestState.Empty,
      topRatedTVs: <TV>[],
    );
  });

  test('Initial state should be equal to default TVListState', () {
    expect(movieHomeCubit.state, movieHomeState);
  });

  blocTest<TVListCubit, TVListState>(
    'Should emit error when fetchNowPlayingTVs is error',
    build: () {
      when(mockGetNowPlayingTVs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('failed fetchNowPlayingTVs')));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchNowPlayingTVs(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const TVListState(
        message: '',
        nowPlayingTVState: RequestState.Loading,
        nowPlayingTVs: <TV>[],
        popularTVsState: RequestState.Empty,
        popularTVs: <TV>[],
        topRatedTVsState: RequestState.Empty,
        topRatedTVs: <TV>[],
      ),
      const TVListState(
        message: 'failed fetchNowPlayingTVs',
        nowPlayingTVState: RequestState.Error,
        nowPlayingTVs: <TV>[],
        popularTVsState: RequestState.Empty,
        popularTVs: <TV>[],
        topRatedTVsState: RequestState.Empty,
        topRatedTVs: <TV>[],
      ),
    ],
  );

  blocTest<TVListCubit, TVListState>(
    'Should emit success when fetchNowPlayingTVs is success',
    build: () {
      when(mockGetNowPlayingTVs.execute())
          .thenAnswer((_) async => Right(mockedTVList));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchNowPlayingTVs(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const TVListState(
        message: '',
        nowPlayingTVState: RequestState.Loading,
        nowPlayingTVs: <TV>[],
        popularTVsState: RequestState.Empty,
        popularTVs: <TV>[],
        topRatedTVsState: RequestState.Empty,
        topRatedTVs: <TV>[],
      ),
      TVListState(
        message: '',
        nowPlayingTVState: RequestState.Loaded,
        nowPlayingTVs: mockedTVList,
        popularTVsState: RequestState.Empty,
        popularTVs: const <TV>[],
        topRatedTVsState: RequestState.Empty,
        topRatedTVs: const <TV>[],
      ),
    ],
  );

  blocTest<TVListCubit, TVListState>(
    'Should emit error when fetchPopularTVs is error',
    build: () {
      when(mockGetPopularTVs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('failed fetchPopularTVs')));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchPopularTVs(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const TVListState(
        message: '',
        nowPlayingTVState: RequestState.Empty,
        nowPlayingTVs: <TV>[],
        popularTVsState: RequestState.Loading,
        popularTVs: <TV>[],
        topRatedTVsState: RequestState.Empty,
        topRatedTVs: <TV>[],
      ),
      const TVListState(
        message: 'failed fetchPopularTVs',
        nowPlayingTVState: RequestState.Empty,
        nowPlayingTVs: <TV>[],
        popularTVsState: RequestState.Error,
        popularTVs: <TV>[],
        topRatedTVsState: RequestState.Empty,
        topRatedTVs: <TV>[],
      ),
    ],
  );

  blocTest<TVListCubit, TVListState>(
    'Should emit success when fetchPopularTVs is success',
    build: () {
      when(mockGetPopularTVs.execute())
          .thenAnswer((_) async => Right(mockedTVList));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchPopularTVs(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const TVListState(
        message: '',
        nowPlayingTVState: RequestState.Empty,
        nowPlayingTVs: <TV>[],
        popularTVsState: RequestState.Loading,
        popularTVs: <TV>[],
        topRatedTVsState: RequestState.Empty,
        topRatedTVs: <TV>[],
      ),
      TVListState(
        message: '',
        nowPlayingTVState: RequestState.Empty,
        nowPlayingTVs: const <TV>[],
        popularTVsState: RequestState.Loaded,
        popularTVs: mockedTVList,
        topRatedTVsState: RequestState.Empty,
        topRatedTVs: const <TV>[],
      ),
    ],
  );

  blocTest<TVListCubit, TVListState>(
    'Should emit error when fetchTopRatedTVs is error',
    build: () {
      when(mockGetTopRatedTVs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('failed fetchTopRatedTVs')));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchTopRatedTVs(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const TVListState(
        message: '',
        nowPlayingTVState: RequestState.Empty,
        nowPlayingTVs: <TV>[],
        popularTVsState: RequestState.Empty,
        popularTVs: <TV>[],
        topRatedTVsState: RequestState.Loading,
        topRatedTVs: <TV>[],
      ),
      const TVListState(
        message: 'failed fetchTopRatedTVs',
        nowPlayingTVState: RequestState.Empty,
        nowPlayingTVs: <TV>[],
        popularTVsState: RequestState.Empty,
        popularTVs: <TV>[],
        topRatedTVsState: RequestState.Error,
        topRatedTVs: <TV>[],
      ),
    ],
  );

  blocTest<TVListCubit, TVListState>(
    'Should emit success when fetchTopRatedTVs is success',
    build: () {
      when(mockGetTopRatedTVs.execute())
          .thenAnswer((_) async => Right(mockedTVList));
      return movieHomeCubit;
    },
    act: (cubit) => cubit.fetchTopRatedTVs(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const TVListState(
        message: '',
        nowPlayingTVState: RequestState.Empty,
        nowPlayingTVs: <TV>[],
        popularTVsState: RequestState.Empty,
        popularTVs: <TV>[],
        topRatedTVsState: RequestState.Loading,
        topRatedTVs: <TV>[],
      ),
      TVListState(
        message: '',
        nowPlayingTVState: RequestState.Empty,
        nowPlayingTVs: const <TV>[],
        popularTVsState: RequestState.Empty,
        popularTVs: const <TV>[],
        topRatedTVsState: RequestState.Loaded,
        topRatedTVs: mockedTVList,
      ),
    ],
  );
}