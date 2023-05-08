import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_created_by_model.dart';
import 'package:core/data/models/tv_detail_response.dart';
import 'package:core/data/models/tv_last_episode_to_air_model.dart';
import 'package:core/data/models/tv_model.dart';
import 'package:core/data/models/tv_network_model.dart';
import 'package:core/data/models/tv_production_country_model.dart';
import 'package:core/data/models/tv_season_model.dart';
import 'package:core/data/models/tv_spoken_language_model.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVRepositoryImpl repository;
  late MockTVRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVRemoteDataSource();
    repository = TVRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  const tTVModel = TVModel(
      posterPath: "/path.jpg",
      popularity: 1.0,
      id: 1,
      backdropPath: "/path.jpg",
      voteAverage: 1.0,
      overview: "Overview",
      firstAirDate: "2020-05-05",
      originCountry: ["US"],
      genreIds: [1],
      originalLanguage: "en",
      voteCount: 1,
      name: "name",
      originalName: "originalName"
  );

  final tTV = TV(
      posterPath: "/path.jpg",
      popularity: 1.0,
      id: 1,
      backdropPath: "/path.jpg",
      voteAverage: 1.0,
      overview: "Overview",
      firstAirDate: "2020-05-05",
      originCountry: const ["US"],
      genreIds: const [1],
      originalLanguage: "en",
      voteCount: 1,
      name: "name",
      originalName: "originalName"
  );

  final tTVModelList = <TVModel>[tTVModel];
  final tTVList = <TV>[tTV];

  group('Now Playing TVs', () {
    test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTVs())
              .thenAnswer((_) async => tTVModelList);
          // act
          final result = await repository.getNowPlayingTVs();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTVs());
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTVList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTVs())
              .thenThrow(ServerException());
          // act
          final result = await repository.getNowPlayingTVs();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTVs());
          expect(result, equals(const Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTVs())
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getNowPlayingTVs();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTVs());
          expect(result,
              equals(
                  const Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Popular TVs', () {
    test('should return tv list when call to data source is success',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTVs())
              .thenAnswer((_) async => tTVModelList);
          // act
          final result = await repository.getPopularTVs();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTVList);
        });

    test(
        'should return server failure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTVs())
              .thenThrow(ServerException());
          // act
          final result = await repository.getPopularTVs();
          // assert
          expect(result, const Left(ServerFailure('')));
        });

    test(
        'should return connection failure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTVs())
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getPopularTVs();
          // assert
          expect(
              result,
              const Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Top Rated TVs', () {
    test('should return tv list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTVs())
              .thenAnswer((_) async => tTVModelList);
          // act
          final result = await repository.getTopRatedTVs();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTVList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTVs())
              .thenThrow(ServerException());
          // act
          final result = await repository.getTopRatedTVs();
          // assert
          expect(result, const Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTVs())
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTopRatedTVs();
          // assert
          expect(
              result,
              const Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Get TV Detail', () {
    const tId = 1;
    final tTVResponse = TvDetailResponse(
        backdropPath: '/path.jpg', 
        createdBy: const [TVCreatedByModel(
            id: 1, 
            creditId: '1', 
            name: 'name', 
            gender: 1, 
            profilePath: '/path.jpg'
        )], 
        episodeRunTime: const [1], 
        firstAirDate: "2020-05-05", 
        genres: const [GenreModel(id: 1, name: 'name')], 
        homepage: 'homepage', 
        id: 1, 
        inProduction: false, 
        languages: const ['en'], 
        lastAirDate: '2020-05-05',
        lastEpisodeToAir: TVLastEpisodeToAirModel(
            airDate: DateTime.parse('2020-05-05'),
            episodeNumber: 1, 
            id: 1, 
            name: 'name', 
            overview: 'overview', 
            productionCode: 'xxx', 
            seasonNumber: 1, 
            stillPath: '/path.jpg', 
            voteAverage: 1.0, 
            voteCount: 1
        ), 
        name: 'name', 
        nextEpisodeToAir: "2020-05-05",
        networks: const [
          TVNetworkModel(
              name: 'name',
              id: 1,
              logoPath: '/logo.path',
              originCountry: 'US'
          )
        ],
        numberOfEpisodes: 12,
        numberOfSeasons: 1,
        originCountry: const ['US'],
        originalLanguage: 'en',
        originalName: 'originalName',
        overview: 'overview', 
        popularity: 1000.0,
        posterPath: '/path.jpg',
        productionCompanies: const [
          TVNetworkModel(
              name: 'name',
              id: 1,
              logoPath: '/logo.path',
              originCountry: 'US'
          )
        ],
        productionCountries: const [
          TVProductionCountryModel(
              iso31661: 'iso31661',
              name: 'name'
          )
        ],
        seasons: [
          TVSeasonModel(
              airDate: DateTime.parse('2020-05-05'),
              episodeCount: 12,
              id: 1,
              name: 'name',
              overview: 'overview',
              posterPath: '/path.jpg',
              seasonNumber: 1
          )
        ],
        spokenLanguages: const [
          TVSpokenLanguageModel(
              englishName: 'englishName',
              iso6391: 'iso6391',
              name: 'name'
          )
        ],
        status: 'Status', 
        tagline: 'Tagline', 
        type: 'type',
        voteAverage: 1.0, 
        voteCount: 1
    );

    test(
        'should return TV data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTVDetail(tId))
              .thenAnswer((_) async => tTVResponse);
          // act
          final result = await repository.getTVDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTVDetail(tId));
          expect(result, equals(Right(mockedTVDetail)));
        });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTVDetail(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTVDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTVDetail(tId));
          expect(result, equals(const Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTVDetail(tId))
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTVDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTVDetail(tId));
          expect(result,
              equals(
                  const Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Get TV Recommendations', () {
    final tTVList = <TVModel>[];
    const tId = 1;

    test('should return data (tv list) when the call is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTVRecommendations(tId))
              .thenAnswer((_) async => tTVList);
          // act
          final result = await repository.getTVRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTVRecommendations(tId));
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tTVList));
        });

    test(
        'should return server failure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTVRecommendations(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTVRecommendations(tId);
          // assertbuild runner
          verify(mockRemoteDataSource.getTVRecommendations(tId));
          expect(result, equals(const Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTVRecommendations(tId))
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTVRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTVRecommendations(tId));
          expect(result,
              equals(
                  const Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Seach TVs', () {
    const tQuery = 'dragonball';

    test('should return tv list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTVs(tQuery))
              .thenAnswer((_) async => tTVModelList);
          // act
          final result = await repository.searchTVs(tQuery);
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTVList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTVs(tQuery))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchTVs(tQuery);
          // assert
          expect(result, const Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTVs(tQuery))
              .thenThrow(const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.searchTVs(tQuery);
          // assert
          expect(
              result,
              const Left(ConnectionFailure('Failed to connect to the network')));
        });
  });
}