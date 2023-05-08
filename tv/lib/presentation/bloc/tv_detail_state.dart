import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TVDetailState extends Equatable {

  final String message;
  final RequestState tvDetailState;
  final TVDetail? tvDetail;
  final RequestState tvRecommendationsState;
  final List<TV> tvRecommendations;
  final bool isAddedtoWatchlist;
  final String watchlistMessage;

  @immutable
  const TVDetailState({
    this.message = '',
    this.tvDetailState = RequestState.Empty,
    this.tvDetail,
    this.tvRecommendationsState = RequestState.Empty,
    this.tvRecommendations = const <TV>[],
    this.isAddedtoWatchlist = false,
    this.watchlistMessage = ''
  });

  TVDetailState copyWith({
    String? message,
    RequestState? tvDetailState,
    TVDetail? tvDetail,
    RequestState? tvRecommendationsState,
    List<TV>? tvRecommendations,
    bool? isAddedtoWatchlist,
    String? watchlistMessage,
  }) {
    return TVDetailState(
        message: message ?? this.message,
        tvDetailState: tvDetailState ?? this.tvDetailState,
        tvDetail: tvDetail ?? this.tvDetail,
        tvRecommendationsState: tvRecommendationsState ?? this.tvRecommendationsState,
        tvRecommendations: tvRecommendations ?? this.tvRecommendations,
        isAddedtoWatchlist: isAddedtoWatchlist ?? this.isAddedtoWatchlist,
        watchlistMessage: watchlistMessage ?? this.watchlistMessage
    );
  }

  @override
  List<Object?> get props => [
    message,
    tvDetailState,
    tvDetail,
    tvRecommendationsState,
    tvRecommendations,
    isAddedtoWatchlist,
    watchlistMessage,
  ];

}