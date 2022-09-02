import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_watchlist.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetWatchListStatus,
  SaveTVWatchlist,
  RemoveWatchlist,
])
void main() {
  late TVDetailNotifier provider;
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveTVWatchlist mockSaveTVWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveTVWatchlist = MockSaveTVWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    provider = TVDetailNotifier(
        getTVDetail: mockGetTVDetail,
        getTVRecommendations: mockGetTVRecommendations,
        getWatchListStatus: mockGetWatchlistStatus,
        saveTVWatchlist: mockSaveTVWatchlist,
        removeWatchlist: mockRemoveWatchlist,
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tId = 1;

  void _arrangeUsecase() {
    when(mockGetTVDetail.execute(tId))
        .thenAnswer((_) async => Right(mockedTVDetail));
    when(mockGetTVRecommendations.execute(tId))
        .thenAnswer((_) async => Right(mockedTVList));
  }

  group('Get TV Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVDetail(tId);
      // assert
      verify(mockGetTVDetail.execute(tId));
      verify(mockGetTVRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTVDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.tv, mockedTVDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation movies when data is gotten successfully',
            () async {
          // arrange
          _arrangeUsecase();
          // act
          await provider.fetchTVDetail(tId);
          // assert
          expect(provider.tvState, RequestState.Loaded);
          expect(provider.tvRecommendations, mockedTVList);
        });
  });

  group('Get TV Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVDetail(tId);
      // assert
      verify(mockGetTVRecommendations.execute(tId));
      expect(provider.tvRecommendations, mockedTVList);
    });

    test('should update recommendation state when data is gotten successfully',
            () async {
          // arrange
          _arrangeUsecase();
          // act
          await provider.fetchTVDetail(tId);
          // assert
          expect(provider.recommendationState, RequestState.Loaded);
          expect(provider.tvRecommendations, mockedTVList);
        });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Right(mockedTVDetail));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTVDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadTVWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveTVWatchlist.execute(mockedTVDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(mockedTVDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addTVWatchlist(mockedTVDetail);
      // assert
      verify(mockSaveTVWatchlist.execute(mockedTVDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(mockedTVDetail.id))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(mockedTVDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeTVFromWatchlist(mockedTVDetail);
      // assert
      verify(mockRemoveWatchlist.execute(mockedTVDetail.id));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveTVWatchlist.execute(mockedTVDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(mockedTVDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addTVWatchlist(mockedTVDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(mockedTVDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveTVWatchlist.execute(mockedTVDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(mockedTVDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addTVWatchlist(mockedTVDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Right(mockedTVList));
      // act
      await provider.fetchTVDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}