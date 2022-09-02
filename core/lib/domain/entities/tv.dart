import 'package:equatable/equatable.dart';

class TV extends Equatable {
  TV({
    required this.posterPath,
    required this.popularity,
    required this.id,
    required this.backdropPath,
    required this.voteAverage,
    required this.overview,
    required this.firstAirDate,
    required this.originCountry,
    required this.genreIds,
    required this.originalLanguage,
    required this.voteCount,
    required this.name,
    required this.originalName,
  });

  String? posterPath;
  double? popularity;
  int id;
  String? backdropPath;
  double? voteAverage;
  String? overview;
  String? firstAirDate;
  List<String>? originCountry;
  List<int>? genreIds;
  String? originalLanguage;
  int? voteCount;
  String? name;
  String? originalName;

  @override
  List<Object?> get props => [
    posterPath,
    popularity,
    id,
    backdropPath,
    voteAverage,
    overview,
    firstAirDate,
    originCountry,
    genreIds,
    originalLanguage,
    voteCount,
    name,
    originalName,
  ];
}