import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MovieDetailState extends Equatable {

  final String message;
  final RequestState movieDetailState;
  late MovieDetail? movieDetail;
  final RequestState movieRecommendationsState;
  final List<Movie> movieRecommendations;
  final bool isAddedtoWatchlist;
  final String watchlistMessage;

  MovieDetailState({
    this.message = '',
    this.movieDetailState = RequestState.Empty,
    this.movieDetail,
    this.movieRecommendationsState = RequestState.Empty,
    this.movieRecommendations = const <Movie>[],
    this.isAddedtoWatchlist = false,
    this.watchlistMessage = ''
  });

  MovieDetailState copyWith({
    String? message,
    RequestState? movieDetailState,
    MovieDetail? movieDetail,
    RequestState? movieRecommendationsState,
    List<Movie>? movieRecommendations,
    bool? isAddedtoWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      message: message ?? this.message,
      movieDetailState: movieDetailState ?? this.movieDetailState,
      movieDetail: movieDetail ?? this.movieDetail,
      movieRecommendationsState: movieRecommendationsState ?? this.movieRecommendationsState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      isAddedtoWatchlist: isAddedtoWatchlist ?? this.isAddedtoWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage
    );
  }

  @override
  List<Object?> get props => [
    message,
    movieDetailState,
    movieDetail,
    movieRecommendationsState,
    movieRecommendations,
    isAddedtoWatchlist,
    watchlistMessage,
  ];

}