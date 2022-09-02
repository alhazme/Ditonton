import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/datasources/watchlist_local_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/data/repositories/watchlist_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/repositories/watchlist_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_now_playing_tvs.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_popular_tvs.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/get_top_rated_tvs.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlists.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_movie_watchlist.dart';
import 'package:core/domain/usecases/save_tv_watchlist.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:core/domain/usecases/search_tvs.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:movie/presentation/provider/movie_search_notifier.dart';
import 'package:movie/presentation/provider/popular_movies_notifier.dart';
import 'package:core/presentation/provider/popular_tvs_notifier.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:core/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:core/presentation/provider/tv_detail_notifier.dart';
import 'package:core/presentation/provider/tv_list_notifier.dart';
import 'package:core/presentation/provider/tv_search_notifier.dart';
import 'package:core/presentation/provider/watchlist_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TVListNotifier(
      getNowPlayingTVs: locator(),
      getPopularTVs: locator(),
      getTopRatedTVs: locator()
    ),
  );
  locator.registerFactory(
    () => TVDetailNotifier(
      getTVDetail: locator(),
      getTVRecommendations: locator(),
      getWatchListStatus: locator(),
      saveTVWatchlist: locator(),
      removeWatchlist: locator()
    ),
  );
  locator.registerFactory(
    () => TVSearchNotifier(
      searchTVs: locator()
    ),
  );
  locator.registerFactory(
    () => PopularTVsNotifier(
      getPopularTVs: locator()
    ),
  );
  locator.registerFactory(
    () => TopRatedTVsNotifier(
      getTopRatedTVs: locator()
    ),
  );
  locator.registerFactory(
    () => WatchlistNotifier(
      getWatchlists: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  // locator.registerLazySingleton(() => GetWatchListMovieStatus(locator()));
  // locator.registerLazySingleton(() => SaveMovieWatchlist(locator()));
  // locator.registerLazySingleton(() => RemoveMovieWatchlist(locator()));
  // locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingTVs(locator()));
  locator.registerLazySingleton(() => GetPopularTVs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVs(locator()));
  locator.registerLazySingleton(() => GetTVDetail(locator()));
  locator.registerLazySingleton(() => GetTVRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTVs(locator()));
  // locator.registerLazySingleton(() => GetWatchListTVStatus(locator()));
  // locator.registerLazySingleton(() => SaveTVWatchlist(locator()));
  // locator.registerLazySingleton(() => RemoveTVWatchlist(locator()));
  // locator.registerLazySingleton(() => GetWatchlistTVs(locator()));

  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => SaveTVWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlists(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      // localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TVRepository>(
    () => TVRepositoryImpl(
      remoteDataSource: locator(),
      // localDataSource: locator()
    ),
  );
  locator.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(
      watchlistLocalDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  // locator.registerLazySingleton<MovieLocalDataSource>(
  //     () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TVRemoteDataSource>(
      () => TVRemoteDataSourceImpl(client: locator()));
  // locator.registerLazySingleton<TVLocalDataSource>(
  //     () => TVLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<WatchlistLocalDataSource>(
      () => WatchlistLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
