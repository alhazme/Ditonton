import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class TVTopRatedState extends Equatable {

  final String message;
  final RequestState topRatedTVsState;
  final List<TV> topRatedTVs;

  const TVTopRatedState({
    this.message = "",
    this.topRatedTVsState = RequestState.Empty,
    this.topRatedTVs = const <TV>[],
  });

  TVTopRatedState copyWith({
    String? message,
    RequestState? topRatedTVsState,
    List<TV>? topRatedTVs,
  }) {
    return TVTopRatedState(
      message: message ?? this.message,
      topRatedTVsState: topRatedTVsState ?? this.topRatedTVsState,
      topRatedTVs: topRatedTVs ?? this.topRatedTVs,
    );
  }

  @override
  List<Object> get props => [
    message,
    topRatedTVsState,
    topRatedTVs,
  ];

}