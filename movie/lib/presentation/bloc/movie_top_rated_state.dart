import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class MovieTopRatedState extends Equatable {

  final String message;
  final RequestState topRatedMoviesState;
  final List<Movie> topRatedMovies;

  const MovieTopRatedState({
    this.message = "",
    this.topRatedMoviesState = RequestState.Empty,
    this.topRatedMovies = const <Movie>[],
  });

  MovieTopRatedState copyWith({
    String? message,
    RequestState? topRatedMoviesState,
    List<Movie>? topRatedMovies,
  }) {
    return MovieTopRatedState(
      message: message ?? this.message,
      topRatedMoviesState: topRatedMoviesState ?? this.topRatedMoviesState,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
    );
  }

  @override
  List<Object> get props => [
    message,
    topRatedMoviesState,
    topRatedMovies,
  ];

}