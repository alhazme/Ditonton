import 'package:ditonton/data/models/watchlist_table.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_created_by.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_last_episode_to_air.dart';
import 'package:ditonton/domain/entities/tv_network.dart';
import 'package:ditonton/domain/entities/tv_production_country.dart';
import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:ditonton/domain/entities/tv_spoken_language.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/domain/entities/genre.dart';

void main() {

  // Arrange
  final movieDetail = MovieDetail(
      adult: false,
      backdropPath: '/path.jpg',
      genres: [
        Genre(id: 1, name: 'name')
      ],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: '/path.jpg',
      releaseDate: '2002-05-05',
      runtime: 1,
      title: 'title',
      voteAverage: 1.0,
      voteCount: 1
  );

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

  final movieWatchlistTable = WatchlistTable(
      id: 1,
      title: 'title',
      posterPath: '/path.jpg',
      overview: 'overview',
      category: 'movie'
  );
  final tvWatchlistTable = WatchlistTable(
      id: 1,
      title: 'name',
      posterPath: '/path.jpg',
      overview: 'overview',
      category: 'tv'
  );

  final movieWatchlistTableJson = {
    'id': 1,
    'title': 'title',
    'poster_path': '/path.jpg',
    'overview': 'overview',
    'category': 'movie'
  };

  final tvWatchlistTableJson = {
    'id': 1,
    'title': 'name',
    'poster_path': '/path.jpg',
    'overview': 'overview',
    'category': 'tv'
  };

  final movieWatchlist = Watchlist(
      id: 1,
      title: 'title',
      posterPath: '/path.jpg',
      overview: 'overview',
      category: 'movie'
  );

  final tvWatchlist = Watchlist(
      id: 1,
      title: 'name',
      posterPath: '/path.jpg',
      overview: 'overview',
      category: 'tv'
  );

  test('should be a equal to WatchlistTable with category movie', () async {
    // Act
    final result = WatchlistTable.fromMovieDetailEntity(movieDetail);
    // Result
    expect(result, movieWatchlistTable);
  });

  test('should be a equal to WatchlistTable with category tv', () async {
    // Act
    final result = WatchlistTable.fromTvDetailEntity(tvDetail);
    // Result
    expect(result, tvWatchlistTable);
  });

  test('should be a equal to WatchlistTable with category movie', () async {
    // Act
    final result = WatchlistTable.fromMap(movieWatchlistTableJson);
    // Result
    expect(result, movieWatchlistTable);
  });

  test('should be a equal to WatchlistTable with category tv', () async {
    // Act
    final result = WatchlistTable.fromMap(tvWatchlistTableJson);
    // Result
    expect(result, tvWatchlistTable);
  });

  test('should be a equal to Watchlist json with category movie', () async {
    // Act
    final result = movieWatchlistTable.toJson();
    // Result
    expect(result, movieWatchlistTableJson);
  });

  test('should be a equal to Watchlist json with category tv', () async {
    // Act
    final result = tvWatchlistTable.toJson();
    // Result
    expect(result, tvWatchlistTableJson);
  });

  test('should be a equal to WatchlistTable Entity with category movie', () async {
    // Act
    final result = movieWatchlistTable.toEntity();
    // Result
    expect(result, movieWatchlist);
  });

  test('should be a equal to WatchlistTable Entity with category tv', () async {
    // Act
    final result = tvWatchlistTable.toEntity();
    // Result
    expect(result, tvWatchlist);
  });
}