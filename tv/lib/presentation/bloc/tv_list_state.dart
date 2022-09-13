import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class TVListState extends Equatable {

  final String message;
  final RequestState nowPlayingTVState;
  final List<TV> nowPlayingTVs;
  final RequestState popularTVsState;
  final List<TV> popularTVs;
  final RequestState topRatedTVsState;
  final List<TV> topRatedTVs;

  const TVListState({
    this.message = "",
    this.nowPlayingTVState = RequestState.Empty,
    this.nowPlayingTVs = const <TV>[],
    this.popularTVsState = RequestState.Empty,
    this.popularTVs = const <TV>[],
    this.topRatedTVsState = RequestState.Empty,
    this.topRatedTVs = const <TV>[],
  });

  TVListState copyWith({
    String? message,
    RequestState? nowPlayingTVState,
    List<TV>? nowPlayingTVs,
    RequestState? popularTVsState,
    List<TV>? popularTVs,
    RequestState? topRatedTVsState,
    List<TV>? topRatedTVs,
  }) {
    return TVListState(
      message: message ?? this.message,
      nowPlayingTVState: nowPlayingTVState ?? this.nowPlayingTVState,
      nowPlayingTVs: nowPlayingTVs ?? this.nowPlayingTVs,
      popularTVsState: popularTVsState ?? this.popularTVsState,
      popularTVs: popularTVs ?? this.popularTVs,
      topRatedTVsState: topRatedTVsState ?? this.topRatedTVsState,
      topRatedTVs: topRatedTVs ?? this.topRatedTVs,
    );
  }

  @override
  List<Object> get props => [
    message,
    nowPlayingTVState,
    nowPlayingTVs,
    popularTVsState,
    popularTVs,
    topRatedTVsState,
    topRatedTVs,
  ];

}