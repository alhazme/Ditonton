import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/watchlist.dart';
import 'package:equatable/equatable.dart';

class WatchlistTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String? category;

  const WatchlistTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.category,
  });

  factory WatchlistTable.fromMovieDetailEntity(MovieDetail movie) => WatchlistTable(
    id: movie.id,
    title: movie.title,
    posterPath: movie.posterPath,
    overview: movie.overview,
    category: 'movie'
  );

  factory WatchlistTable.fromTvDetailEntity(TVDetail tv) => WatchlistTable(
    id: tv.id,
    title: tv.name,
    posterPath: tv.posterPath,
    overview: tv.overview,
    category: 'tv'
  );

  factory WatchlistTable.fromMap(Map<String, dynamic> map) => WatchlistTable(
    id: map['id'],
    title: map['title'],
    posterPath: map['poster_path'],
    overview: map['overview'],
    category: map['category'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'poster_path': posterPath,
    'overview': overview,
    'category': category
  };

  Watchlist toEntity() => Watchlist(
      id: id,
      title: title?? "",
      posterPath: posterPath?? "",
      overview: overview?? "",
      category: category?? ""
  );

  @override
  List<Object?> get props => [id, title, posterPath, overview, category];
}
