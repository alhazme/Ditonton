import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_created_by_model.dart';
import 'package:core/data/models/tv_detail_response.dart';
import 'package:core/data/models/tv_last_episode_to_air_model.dart';
import 'package:core/data/models/tv_network_model.dart';
import 'package:core/data/models/tv_production_country_model.dart';
import 'package:core/data/models/tv_season_model.dart';
import 'package:core/data/models/tv_spoken_language_model.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_created_by.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/tv_last_episode_to_air.dart';
import 'package:core/domain/entities/tv_network.dart';
import 'package:core/domain/entities/tv_production_country.dart';
import 'package:core/domain/entities/tv_season.dart';
import 'package:core/domain/entities/tv_spoken_language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Arrange
  final tvDetailResponse = TvDetailResponse(
      backdropPath: '/path.jpg',
      createdBy: [
        TVCreatedByModel(
          id: 1,
          creditId: '1',
          name: 'name',
          gender: 1,
          profilePath: '/path.jpg'
        )
      ],
      episodeRunTime: [1],
      firstAirDate: "2020-05-05",
      genres: [GenreModel(id: 1, name: 'name')],
      homepage: 'homepage',
      id: 1,
      inProduction: false,
      languages: ['en'],
      lastAirDate: "2020-05-05",
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
      networks: [
        TVNetworkModel(
            name: 'name',
            id: 1,
            logoPath: '/logo.path',
            originCountry: 'US'
        )
      ],
      numberOfEpisodes: 12,
      numberOfSeasons: 1,
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1000.0,
      posterPath: '/path.jpg',
      productionCompanies: [
        TVNetworkModel(
            name: 'name',
            id: 1,
            logoPath: '/logo.path',
            originCountry: 'US'
        )
      ],
      productionCountries: [
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
      spokenLanguages: [
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

  final tvDetailResponseJson = {
    'backdrop_path': '/path.jpg',
    'created_by': [
      {
        'id': 1,
        'credit_id': '1',
        'name': 'name',
        'gender': 1,
        'profile_path': '/path.jpg'
      }
    ],
    'episode_run_time': [1],
    'first_air_date': "2020-05-05",
    'genres': [
      {
        'id': 1,
        'name': 'name'
      }
    ],
    'homepage': 'homepage',
    'id': 1,
    'in_production': false,
    'languages': ['en'],
    'last_air_date': "2020-05-05",
    'last_episode_to_air': {
      'air_date': '2020-05-05',
      'episode_number': 1,
      'id': 1,
      'name': 'name',
      'overview': 'overview',
      'production_code': 'xxx',
      'season_number': 1,
      'still_path': '/path.jpg',
      'vote_average': 1.0,
      'vote_count': 1
    },
    'name': 'name',
    'next_episode_to_air': "2020-05-05",
    'networks': [
      {
        'name': 'name',
        'id': 1,
        'logo_path': '/logo.path',
        'origin_country': 'US'
      }
    ],
    'number_of_episodes': 12,
    'number_of_seasons': 1,
    'origin_country': ['US'],
    'original_language': 'en',
    'original_name': 'originalName',
    'overview': 'overview',
    'popularity': 1000.0,
    'poster_path': '/path.jpg',
    'production_companies': [
      {
        'name': 'name',
        'id': 1,
        'logo_path': '/logo.path',
        'origin_country': 'US'
      }
    ],
    'production_countries': [
      {
        'iso_3166_1': 'iso31661',
        'name': 'name'
      }
    ],
    'seasons': [
      {
        'air_date': '2020-05-05',
        'episode_count': 12,
        'id': 1,
        'name': 'name',
        'overview': 'overview',
        'poster_path': '/path.jpg',
        'season_number': 1
      }
    ],
    'spoken_languages': [
      {
        'english_name': 'englishName',
        'iso_639_1': 'iso6391',
        'name': 'name'
      }
    ],
    'status': 'Status',
    'tagline': 'Tagline',
    'type': 'type',
    'vote_average': 1.0,
    'vote_count': 1
  };
  final tvDetail = TVDetail(
      backdropPath: '/path.jpg',
      createdBy: [TVCreatedBy(
          id: 1,
          creditId: '1',
          name: 'name',
          gender: 1,
          profilePath: '/path.jpg'
      )],
      episodeRunTime: [1],
      firstAirDate: "2020-05-05",
      genres: [Genre(id: 1, name: 'name')],
      homepage: 'homepage',
      id: 1,
      inProduction: false,
      languages: ['en'],
      lastAirDate: "2020-05-05",
      lastEpisodeToAir: TVLastEpisodeToAir(
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
      networks: [
        TVNetwork(
            name: 'name',
            id: 1,
            logoPath: '/logo.path',
            originCountry: 'US'
        )
      ],
      numberOfEpisodes: 12,
      numberOfSeasons: 1,
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1000.0,
      posterPath: '/path.jpg',
      productionCompanies: [
        TVNetwork(
            name: 'name',
            id: 1,
            logoPath: '/logo.path',
            originCountry: 'US'
        )
      ],
      productionCountries: [
        TVProductionCountry(
            iso31661: 'iso31661',
            name: 'name'
        )
      ],
      seasons: [
        TVSeason(
            airDate: DateTime.parse('2020-05-05'),
            episodeCount: 12,
            id: 1,
            name: 'name',
            overview: 'overview',
            posterPath: '/path.jpg',
            seasonNumber: 1
        )
      ],
      spokenLanguages: [
        TVSpokenLanguage(
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

  test('should be a equal to TVDetailResponse model', () async {
    // Act
    final result = TvDetailResponse.fromJson(tvDetailResponseJson);
    // Result
    expect(result, tvDetailResponse);
  });
  test('should be a equal to TVDetailResponse model', () async {
    // Act
    final result = tvDetailResponse.toJson();
    // Result
    expect(result, tvDetailResponseJson);
  });
  test('should be a equal to TVDetailResponse Entity', () async {
    // Act
    final result = tvDetailResponse.toEntity();
    // Result
    expect(result, tvDetail);
  });
}