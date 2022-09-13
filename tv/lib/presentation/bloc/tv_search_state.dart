import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class TVSearchState extends Equatable {

  final String message;
  final RequestState state;
  final List<TV> searchResult;

  const TVSearchState({
    this.message = "",
    this.state = RequestState.Empty,
    this.searchResult = const <TV>[],
  });

  TVSearchState copyWith({
    String? message,
    RequestState? state,
    List<TV>? searchResult,
  }) {
    return TVSearchState(
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