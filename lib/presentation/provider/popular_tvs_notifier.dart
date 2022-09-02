import 'package:core/utils/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:flutter/cupertino.dart';

class PopularTVsNotifier extends ChangeNotifier {
  final GetPopularTVs getPopularTVs;

  PopularTVsNotifier({required this.getPopularTVs});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;
  List<TV> _tvs = [];
  List<TV> get tvs => _tvs;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTVs() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVs.execute();

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