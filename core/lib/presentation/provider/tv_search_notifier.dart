import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/search_tvs.dart';
import 'package:flutter/cupertino.dart';

class TVSearchNotifier extends ChangeNotifier {
  final SearchTVs searchTVs;

  TVSearchNotifier({required this.searchTVs});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TV> _searchResult = [];
  List<TV> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTVSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTVs.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvs) {
        _searchResult = tvs;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}