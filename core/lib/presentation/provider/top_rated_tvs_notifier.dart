import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_top_rated_tvs.dart';
import 'package:flutter/cupertino.dart';

class TopRatedTVsNotifier extends ChangeNotifier {
  final GetTopRatedTVs getTopRatedTVs;

  TopRatedTVsNotifier({required this.getTopRatedTVs});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;
  List<TV> _tvs = [];
  List<TV> get tvs => _tvs;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTVs() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVs.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvsData) {
        _tvs = tvsData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}