import 'package:core/data/models/watchlist_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_created_by.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/tv_last_episode_to_air.dart';
import 'package:core/domain/entities/tv_network.dart';
import 'package:core/domain/entities/tv_production_country.dart';
import 'package:core/domain/entities/tv_season.dart';
import 'package:core/domain/entities/tv_spoken_language.dart';
import 'package:core/domain/entities/watchlist.dart';

final mockedMovie = Movie(
  adult: false,
  backdropPath: '/path.jpg',
  genreIds: const [1],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  popularity: 1000.0,
  posterPath: '/path.jpg',
  releaseDate: '2002-05-05',
  title: 'title',
  video: false,
  voteAverage: 1.0,
  voteCount: 1,
);

final mockedMovieList = [mockedMovie];

const mockedMovieDetail = MovieDetail(
  adult: false,
  backdropPath: '/path.jpg',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: '/path.jpg',
  releaseDate: '2020-05-05',
  runtime: 120,
  title: 'title',
  voteAverage: 1.0,
  voteCount: 1,
);

final mockedTV = TV(
    posterPath: '/path.jpg',
    popularity: 1000.0,
    id: 1,
    backdropPath: '/path.jpg',
    voteAverage: 1.0,
    overview: 'overview',
    firstAirDate: '2020-05-05',
    originCountry: const ['US'],
    genreIds: const [1],
    originalLanguage: 'en',
    voteCount: 1,
    name: 'name',
    originalName: 'originalName'
);

final mockedTVList = [mockedTV];

final mockedTVDetail = TVDetail(
    backdropPath: '/path.jpg',
    createdBy: const [TVCreatedBy(
        id: 1,
        creditId: '1',
        name: 'name',
        gender: 1,
        profilePath: '/path.jpg'
    )],
    episodeRunTime: const [1],
    firstAirDate: "2020-05-05",
    genres: const [Genre(id: 1, name: 'name')],
    homepage: 'homepage',
    id: 1,
    inProduction: false,
    languages: const ['en'],
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
    networks: const [
      TVNetwork(
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
      TVNetwork(
          name: 'name',
          id: 1,
          logoPath: '/logo.path',
          originCountry: 'US'
      )
    ],
    productionCountries: const [
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
    spokenLanguages: const [
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

const mockedWatchlistMovie = Watchlist(
    id: 1,
    title: 'title',
    posterPath: '/path.jpg',
    overview: 'overview',
    category: 'movie'
);

const mockedWatchlistTV = Watchlist(
  id: 1,
  title: 'name',
  posterPath: '/path.jpg',
  overview: 'overview',
  category: 'tv'
);

final mockedWatchlists = [
  mockedWatchlistMovie, mockedWatchlistTV
];

const mockedMovieWatchlistTable = WatchlistTable(
  id: 1,
  title: 'title',
  posterPath: '/path.jpg',
  overview: 'overview',
  category: 'movie'
);

const mockedTVWatchlistTable = WatchlistTable(
  id: 1,
  title: 'name',
  posterPath: '/path.jpg',
  overview: 'overview',
  category: 'tv'
);

final mockedMovieMap = {
  'id': 1,
  'overview': 'overview',
  'poster_path': '/path.jpg',
  'title': 'title',
  'category': 'movie',
};

final mockedTVMap = {
  'id': 1,
  'overview': 'overview',
  'poster_path': '/path.jpg',
  'title': 'name',
  'category': 'tv',
};
