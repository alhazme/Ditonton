import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class MovieHomeState extends Equatable {

  final String message;
  final RequestState nowPlayingState;
  final List<Movie> nowPlayingMovies;
  final RequestState popularMoviesState;
  final List<Movie> popularMovies;
  final RequestState topRatedMoviesState;
  final List<Movie> topRatedMovies;

  const MovieHomeState({
    this.message = "",
    this.nowPlayingState = RequestState.Empty,
    this.nowPlayingMovies = const <Movie>[],
    this.popularMoviesState = RequestState.Empty,
    this.popularMovies = const <Movie>[],
    this.topRatedMoviesState = RequestState.Empty,
    this.topRatedMovies = const <Movie>[],
  });

  MovieHomeState copyWith({
    String? message,
    RequestState? nowPlayingState,
    List<Movie>? nowPlayingMovies,
    RequestState? popularMoviesState,
    List<Movie>? popularMovies,
    RequestState? topRatedMoviesState,
    List<Movie>? topRatedMovies,
  }) {
    return MovieHomeState(
      message: message ?? this.message,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMoviesState: popularMoviesState ?? this.popularMoviesState,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMoviesState: topRatedMoviesState ?? this.topRatedMoviesState,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
    );
  }

  @override
  List<Object> get props => [
    message,
    nowPlayingState,
    nowPlayingMovies,
    popularMoviesState,
    popularMovies,
    topRatedMoviesState,
    topRatedMovies,
  ];

}