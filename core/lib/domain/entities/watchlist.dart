import 'package:equatable/equatable.dart';

class Watchlist extends Equatable {

  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final String category;

  Watchlist({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.category,
  });

  @override
  List<Object> get props => [id, title, posterPath, overview, category];
}
