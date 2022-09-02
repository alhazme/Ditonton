import 'dart:convert';

import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/utils/exception.dart';
import 'package:core/data/models/tv_detail_response.dart';
import 'package:core/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TVRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing TVs', () {
    final tTVList = TVResponse.fromJson(
        json.decode(readJson('dummy_data/tv_now_playing.json')))
        .tvList;

    test('should return list of TV Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_now_playing.json'), 200));
          // act
          final result = await dataSource.getNowPlayingTVs();
          // assert
          expect(result, equals(tTVList));
        });

    test('should throw a ServerException when the response code is 404 or other', () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getNowPlayingTVs();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Popular TVs', () {
    final tTVList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/tv_popular.json')))
            .tvList;

    test('should return list of tvs when response is success (200)',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_popular.json'), 200));
          // act
          final result = await dataSource.getPopularTVs();
          // assert
          expect(result, tTVList);
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getPopularTVs();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Top Rated TVs', () {
    final tTVList = TVResponse.fromJson(
        json.decode(readJson('dummy_data/tv_top_rated.json')))
        .tvList;

    test('should return list of tvs when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedTVs();
      // assert
      expect(result, tTVList);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTopRatedTVs();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get tv detail', () {
    final tId = 1;
    final tTVDetail = TvDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_detail.json'), 200));
      // act
      final result = await dataSource.getTVDetail(tId);
      // assert
      expect(result, equals(tTVDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTVDetail(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get tv recommendations', () {
    final tTVList = TVResponse.fromJson(
        json.decode(readJson('dummy_data/tv_recommendations.json')))
        .tvList;
    final tId = 1;

    test('should return list of TV Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_recommendations.json'), 200));
          // act
          final result = await dataSource.getTVRecommendations(tId);
          // assert
          expect(result, equals(tTVList));
        });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTVRecommendations(tId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('search tvs', () {
    final tSearchResult = TVResponse.fromJson(
        json.decode(readJson('dummy_data/search_dragonball_tv.json')))
        .tvList;
    final tQuery = 'dragonball';

    test('should return list of tvs when response code is 200', () async {
      // arrange
      when(mockHttpClient
          .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
          readJson('dummy_data/search_dragonball_tv.json'), 200));
      // act
      final result = await dataSource.searchTVs(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.searchTVs(tQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

}
