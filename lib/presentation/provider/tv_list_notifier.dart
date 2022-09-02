import 'package:core/utils/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tvs.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:flutter/material.dart';

class TVListNotifier extends ChangeNotifier {

  // Now Playing / On The Air TVs
  var _nowPlayingTVs = <TV>[];
  List<TV> get nowPlayingTVs => _nowPlayingTVs;
  RequestState _nowPlayingTVsState = RequestState.Empty;
  RequestState get nowPlayingTVsState => _nowPlayingTVsState;

  // Popular TVs
  var _popularTVs = <TV>[];
  List<TV> get popularTVs => _popularTVs;
  RequestState _popularTVsState = RequestState.Empty;
  RequestState get popularTVsState => _popularTVsState;

  // Top Rated TVs
  var _topRatedTVs = <TV>[];
  List<TV> get topRatedTVs => _topRatedTVs;
  RequestState _topRatedTVsState = RequestState.Empty;
  RequestState get topRatedTVsState => _topRatedTVsState;

  String _message = '';
  String get message => _message;

  TVListNotifier({
    required this.getNowPlayingTVs,
    required this.getPopularTVs,
    required this.getTopRatedTVs,
  });

  final GetNowPlayingTVs getNowPlayingTVs;
  final GetPopularTVs getPopularTVs;
  final GetTopRatedTVs getTopRatedTVs;

  Future<void> fetchNowPlayingTVs() async {
    _nowPlayingTVsState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTVs.execute();
    result.fold(
      (failure) {
        _nowPlayingTVsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _nowPlayingTVsState = RequestState.Loaded;
        _nowPlayingTVs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTVs() async {
    _popularTVsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVs.execute();
    result.fold(
      (failure) {
        _popularTVsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _popularTVsState = RequestState.Loaded;
        _popularTVs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVs() async {
    _topRatedTVsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVs.execute();
    result.fold(
      (failure) {
        _topRatedTVsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _topRatedTVsState = RequestState.Loaded;
        _topRatedTVs = tvsData;
        notifyListeners();
      },
    );
  }
}