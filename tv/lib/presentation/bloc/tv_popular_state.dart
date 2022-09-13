import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class TVPopularState extends Equatable {

  final String message;
  final RequestState popularTVsState;
  final List<TV> popularTVs;

  const TVPopularState({
    this.message = "",
    this.popularTVsState = RequestState.Empty,
    this.popularTVs = const <TV>[],
  });

  TVPopularState copyWith({
    String? message,
    RequestState? popularTVsState,
    List<TV>? popularTVs,
  }) {
    return TVPopularState(
      message: message ?? this.message,
      popularTVsState: popularTVsState ?? this.popularTVsState,
      popularTVs: popularTVs ?? this.popularTVs,
    );
  }

  @override
  List<Object> get props => [
    message,
    popularTVsState,
    popularTVs,
  ];

}