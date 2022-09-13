import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class MoviePopularState extends Equatable {

  final String message;
  final RequestState popularMoviesState;
  final List<Movie> popularMovies;

  const MoviePopularState({
    this.message = "",
    this.popularMoviesState = RequestState.Empty,
    this.popularMovies = const <Movie>[],
  });

  MoviePopularState copyWith({
    String? message,
    RequestState? popularMoviesState,
    List<Movie>? popularMovies,
  }) {
    return MoviePopularState(
      message: message ?? this.message,
      popularMoviesState: popularMoviesState ?? this.popularMoviesState,
      popularMovies: popularMovies ?? this.popularMovies,
    );
  }

  @override
  List<Object> get props => [
    message,
    popularMoviesState,
    popularMovies,
  ];

}