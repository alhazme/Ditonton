import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/save_tv_watchlist.dart';
import 'package:tv/presentation/bloc/tv_detail_cubit.dart';
import 'package:tv/presentation/bloc/tv_detail_state.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetWatchListStatus,
  SaveTVWatchlist,
  RemoveWatchlist,
])
void main() {

  late TVDetailCubit tvDetailCubit;
  late TVDetailState tvDetailState;
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveTVWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  final tId = 1;

  setUp(() {
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveTVWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    tvDetailCubit = TVDetailCubit(
        getTVDetail: mockGetTVDetail,
        getTVRecommendations: mockGetTVRecommendations,
        getWatchListStatus: mockGetWatchlistStatus,
        saveTVWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist
    );
    tvDetailState = TVDetailState(
        message: "",
        tvDetailState: RequestState.Empty,
        tvDetail: null,
        tvRecommendationsState: RequestState.Empty,
        tvRecommendations: <TV>[],
        isAddedtoWatchlist: false,
        watchlistMessage: ""
    );
  });

  test('Initial state should be equal to default TVDetailState', () {
    expect(tvDetailCubit.state, tvDetailState);
  });

  blocTest<TVDetailCubit, TVDetailState>(
    'Should emit error when getTVDetail is error',
    build: () {
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('failed fetchTVDetail')));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('failed fetchTVRecommendations')));
      when(mockGetWatchlistStatus.execute(tId))
          .thenAnswer((_) async => false);
      return tvDetailCubit;
    },
    act: (cubit) => cubit.fetchTVDetail(tId),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      TVDetailState(
          message: '',
          tvDetailState: RequestState.Loading,
          tvDetail: null,
          tvRecommendationsState: RequestState.Empty,
          tvRecommendations: <TV>[],
          isAddedtoWatchlist: false,
          watchlistMessage: ''
      ),
      TVDetailState(
          message: 'failed fetchTVDetail',
          tvDetailState: RequestState.Error,
          tvDetail: null,
          tvRecommendationsState: RequestState.Empty,
          tvRecommendations: <TV>[],
          isAddedtoWatchlist: false,
          watchlistMessage: ''
      ),
    ],
  );

  blocTest<TVDetailCubit, TVDetailState>(
    'Should emit error when getTVDetail is success but getTVRecommendations is error',
    build: () {
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Right(mockedTVDetail));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('failed fetchTVRecommendations')));
      when(mockGetWatchlistStatus.execute(tId))
          .thenAnswer((_) async => false);
      return tvDetailCubit;
    },
    act: (cubit) => cubit.fetchTVDetail(tId),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      TVDetailState(
          message: '',
          tvDetailState: RequestState.Loading,
          tvDetail: null,
          tvRecommendationsState: RequestState.Empty,
          tvRecommendations: <TV>[],
          isAddedtoWatchlist: false,
          watchlistMessage: ''
      ),
      TVDetailState(
          message: '',
          tvDetailState: RequestState.Loaded,
          tvDetail: mockedTVDetail,
          tvRecommendationsState: RequestState.Empty,
          tvRecommendations: <TV>[],
          isAddedtoWatchlist: false,
          watchlistMessage: ''
      ),
      TVDetailState(
          message: 'failed fetchTVRecommendations',
          tvDetailState: RequestState.Loaded,
          tvDetail: mockedTVDetail,
          tvRecommendationsState: RequestState.Error,
          tvRecommendations: <TV>[],
          isAddedtoWatchlist: false,
          watchlistMessage: ''
      )
    ],
  );

  blocTest<TVDetailCubit, TVDetailState>(
    'Should emit error when addWatchlist is error',
    build: () {
      when(mockSaveWatchlist.execute(mockedTVDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('failed saveTVWatchlist')));
      return tvDetailCubit;
    },
    act: (cubit) => cubit.addWatchlist(mockedTVDetail),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      TVDetailState(
          message: '',
          tvDetailState: RequestState.Empty,
          tvDetail: null,
          tvRecommendationsState: RequestState.Empty,
          tvRecommendations: <TV>[],
          isAddedtoWatchlist: false,
          watchlistMessage: 'failed saveTVWatchlist'
      ),
    ],
  );

  blocTest<TVDetailCubit, TVDetailState>(
    'Should emit success when addWatchlist is success',
    build: () {
      when(mockSaveWatchlist.execute(mockedTVDetail))
          .thenAnswer((_) async => Right(TVDetailCubit.watchlistAddSuccessMessage));
      return tvDetailCubit;
    },
    act: (cubit) => cubit.addWatchlist(mockedTVDetail),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      TVDetailState(
          isAddedtoWatchlist: true,
          watchlistMessage: TVDetailCubit.watchlistAddSuccessMessage
      ),
    ],
  );

  blocTest<TVDetailCubit, TVDetailState>(
    'Should emit error when removeFromWatchlist is error',
    build: () {
      when(mockRemoveWatchlist.execute(tId))
          .thenAnswer((_) async => Left(DatabaseFailure('failed removeFromWatchlist')));
      return tvDetailCubit;
    },
    act: (cubit) => cubit.removeFromWatchlist(tId),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      TVDetailState(
          isAddedtoWatchlist: true,
          watchlistMessage: 'failed removeFromWatchlist'
      ),
    ],
  );

  blocTest<TVDetailCubit, TVDetailState>(
    'Should emit success when removeFromWatchlist is success',
    build: () {
      when(mockRemoveWatchlist.execute(tId))
          .thenAnswer((_) async => Right(TVDetailCubit.watchlistRemoveSuccessMessage));
      return tvDetailCubit;
    },
    act: (cubit) => cubit.removeFromWatchlist(tId),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      TVDetailState(
          isAddedtoWatchlist: false,
          watchlistMessage: TVDetailCubit.watchlistRemoveSuccessMessage
      ),
    ],
  );
}