import 'package:core/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class MovieSearchState extends Equatable {

  final String message;
  final RequestState state;
  final List<Movie> searchResult;

  const MovieSearchState({
    this.message = "",
    this.state = RequestState.Empty,
    this.searchResult = const <Movie>[],
  });

  MovieSearchState copyWith({
    String? message,
    RequestState? state,
    List<Movie>? searchResult,
  }) {
    return MovieSearchState(
      message: message ?? this.message,
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
    );
  }

  @override
  List<Object> get props => [
    message,
    state,
    searchResult,
  ];

}