import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../tv/test/presentation/provider/tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVs, GetPopularTVs, GetTopRatedTVs])
void main() {
  late TVListNotifier provider;
  late MockGetNowPlayingTVs mockGetNowPlayingTVs;
  late MockGetPopularTVs mockGetPopularTVs;
  late MockGetTopRatedTVs mockGetTopRatedTVs;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTVs = MockGetNowPlayingTVs();
    mockGetPopularTVs = MockGetPopularTVs();
    mockGetTopRatedTVs = MockGetTopRatedTVs();
    provider = TVListNotifier(
        getNowPlayingTVs: mockGetNowPlayingTVs,
        getPopularTVs: mockGetPopularTVs,
        getTopRatedTVs: mockGetTopRatedTVs
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  group('now playing tvs', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingTVsState, equals(RequestState.Empty));
    });

    test('should get data from the usecases', () async {
      // arrange
      when(mockGetNowPlayingTVs.execute())
          .thenAnswer((_) async => Right(mockedTVList));
      // act
      provider.fetchNowPlayingTVs();
      // assert
      verify(mockGetNowPlayingTVs.execute());
    });

    test('should change state to Loading when usecases is called', () {
      // arrange
      when(mockGetNowPlayingTVs.execute())
          .thenAnswer((_) async => Right(mockedTVList));
      // act
      provider.fetchNowPlayingTVs();
      // assert
      expect(provider.nowPlayingTVsState, RequestState.Loading);
    });

    test('should change tvs when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlayingTVs.execute())
          .thenAnswer((_) async => Right(mockedTVList));
      // act
      await provider.fetchNowPlayingTVs();
      // assert
      expect(provider.nowPlayingTVsState, RequestState.Loaded);
      expect(provider.nowPlayingTVs, mockedTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlayingTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlayingTVs();
      // assert
      expect(provider.nowPlayingTVsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tvs', () {
    test('should change state to loading when usecases is called', () async {
      // arrange
      when(mockGetPopularTVs.execute())
          .thenAnswer((_) async => Right(mockedTVList));
      // act
      provider.fetchPopularTVs();
      // assert
      expect(provider.popularTVsState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change tvs data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetPopularTVs.execute())
              .thenAnswer((_) async => Right(mockedTVList));
          // act
          await provider.fetchPopularTVs();
          // assert
          expect(provider.popularTVsState, RequestState.Loaded);
          expect(provider.popularTVs, mockedTVList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTVs();
      // assert
      expect(provider.popularTVsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tvs', () {
    test('should change state to loading when usecases is called', () async {
      // arrange
      when(mockGetTopRatedTVs.execute())
          .thenAnswer((_) async => Right(mockedTVList));
      // act
      provider.fetchTopRatedTVs();
      // assert
      expect(provider.topRatedTVsState, RequestState.Loading);
    });

    test('should change tvs data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetTopRatedTVs.execute())
              .thenAnswer((_) async => Right(mockedTVList));
          // act
          await provider.fetchTopRatedTVs();
          // assert
          expect(provider.topRatedTVsState, RequestState.Loaded);
          expect(provider.topRatedTVs, mockedTVList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTVs();
      // assert
      expect(provider.topRatedTVsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}