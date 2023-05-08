import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_created_by_model.dart';
import 'package:core/data/models/tv_last_episode_to_air_model.dart';
import 'package:core/data/models/tv_network_model.dart';
import 'package:core/data/models/tv_production_country_model.dart';
import 'package:core/data/models/tv_season_model.dart';
import 'package:core/data/models/tv_spoken_language_model.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvDetailResponse extends Equatable {
  const TvDetailResponse({
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name,
    required this.nextEpisodeToAir,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.seasons,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  final String backdropPath;
  final List<TVCreatedByModel> createdBy;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String lastAirDate;
  final TVLastEpisodeToAirModel lastEpisodeToAir;
  final String name;
  final dynamic nextEpisodeToAir;
  final List<TVNetworkModel> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<TVNetworkModel> productionCompanies;
  final List<TVProductionCountryModel> productionCountries;
  final List<TVSeasonModel> seasons;
  final List<TVSpokenLanguageModel> spokenLanguages;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) => TvDetailResponse(
    backdropPath: json["backdrop_path"] ?? "",
    createdBy: List<TVCreatedByModel>.from(json["created_by"].map((x) => TVCreatedByModel.fromJson(x))),
    episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
    firstAirDate: json["first_air_date"] ?? "",
    genres: List<GenreModel>.from(json["genres"].map((x) => GenreModel.fromJson(x))),
    homepage: json["homepage"],
    id: json["id"],
    inProduction: json["in_production"],
    languages: List<String>.from(json["languages"].map((x) => x)),
    lastAirDate: json["last_air_date"] ?? "",
    lastEpisodeToAir: TVLastEpisodeToAirModel.fromJson(json["last_episode_to_air"]),
    name: json["name"],
    nextEpisodeToAir: json["next_episode_to_air"],
    networks: List<TVNetworkModel>.from(json["networks"].map((x) => TVNetworkModel.fromJson(x))),
    numberOfEpisodes: json["number_of_episodes"],
    numberOfSeasons: json["number_of_seasons"],
    originCountry: List<String>.from(json["origin_country"].map((x) => x)),
    originalLanguage: json["original_language"],
    originalName: json["original_name"],
    overview: json["overview"],
    popularity: json["popularity"].toDouble(),
    posterPath: json["poster_path"] ?? "",
    productionCompanies: List<TVNetworkModel>.from(json["production_companies"].map((x) => TVNetworkModel.fromJson(x))),
    productionCountries: List<TVProductionCountryModel>.from(json["production_countries"].map((x) => TVProductionCountryModel.fromJson(x))),
    seasons: List<TVSeasonModel>.from(json["seasons"].map((x) => TVSeasonModel.fromJson(x))),
    spokenLanguages: List<TVSpokenLanguageModel>.from(json["spoken_languages"].map((x) => TVSpokenLanguageModel.fromJson(x))),
    status: json["status"],
    tagline: json["tagline"],
    type: json["type"],
    voteAverage: json["vote_average"].toDouble(),
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "backdrop_path": backdropPath,
    "created_by": List<dynamic>.from(createdBy.map((x) => x.toJson())),
    "episode_run_time": List<dynamic>.from(episodeRunTime.map((x) => x)),
    "first_air_date": firstAirDate,
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "homepage": homepage,
    "id": id,
    "in_production": inProduction,
    "languages": List<dynamic>.from(languages.map((x) => x)),
    "last_air_date": lastAirDate,
    "last_episode_to_air": lastEpisodeToAir.toJson(),
    "name": name,
    "next_episode_to_air": nextEpisodeToAir,
    "networks": List<dynamic>.from(networks.map((x) => x.toJson())),
    "number_of_episodes": numberOfEpisodes,
    "number_of_seasons": numberOfSeasons,
    "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
    "original_language": originalLanguage,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "production_companies": List<dynamic>.from(productionCompanies.map((x) => x.toJson())),
    "production_countries": List<dynamic>.from(productionCountries.map((x) => x.toJson())),
    "seasons": List<dynamic>.from(seasons.map((x) => x.toJson())),
    "spoken_languages": List<dynamic>.from(spokenLanguages.map((x) => x.toJson())),
    "status": status,
    "tagline": tagline,
    "type": type,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  TVDetail toEntity() {
    return TVDetail(
        backdropPath: backdropPath,
        createdBy: createdBy.map((createdBy) => createdBy.toEntity()).toList(),
        episodeRunTime: episodeRunTime,
        firstAirDate: firstAirDate,
        genres: genres.map((genre) => genre.toEntity()).toList(),
        homepage: homepage,
        id: id,
        inProduction: inProduction,
        languages: languages,
        lastAirDate: lastAirDate,
        lastEpisodeToAir: lastEpisodeToAir.toEntity(),
        name: name,
        nextEpisodeToAir: nextEpisodeToAir,
        networks: networks.map((network) => network.toEntity()).toList(),
        numberOfEpisodes: numberOfEpisodes,
        numberOfSeasons: numberOfSeasons,
        originCountry: originCountry,
        originalLanguage: originalLanguage,
        originalName: originalName,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        productionCompanies: productionCompanies.map((productionCompany) => productionCompany.toEntity()).toList(),
        productionCountries: productionCountries.map((productionCountry) => productionCountry.toEntity()).toList(),
        seasons: seasons.map((season) => season.toEntity()).toList(),
        spokenLanguages: spokenLanguages.map((spokenLanguage) => spokenLanguage.toEntity()).toList(),
        status: status,
        tagline: tagline,
        type: type,
        voteAverage: voteAverage,
        voteCount: voteCount
    );
  }

  @override
  List<Object?> get props => [
    backdropPath,
    createdBy,
    episodeRunTime,
    firstAirDate,
    genres,
    homepage,
    id,
    inProduction,
    languages,
    lastAirDate,
    lastEpisodeToAir,
    name,
    nextEpisodeToAir,
    networks,
    numberOfEpisodes,
    numberOfSeasons,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    productionCompanies,
    productionCountries,
    seasons,
    spokenLanguages,
    status,
    tagline,
    type,
    voteAverage,
    voteCount,
  ];
}