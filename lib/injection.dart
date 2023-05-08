import 'dart:io';

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
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:movie/presentation/bloc/movie_home_cubit.dart';
import 'package:movie/presentation/bloc/movie_popular_cubit.dart';
import 'package:movie/presentation/bloc/movie_search_cubit.dart';
import 'package:movie/presentation/bloc/movie_top_rated_cubit.dart';
import 'package:tv/presentation/bloc/tv_detail_cubit.dart';
import 'package:tv/presentation/bloc/tv_list_cubit.dart';
import 'package:tv/presentation/bloc/tv_popular_cubit.dart';
import 'package:tv/presentation/bloc/tv_search_cubit.dart';
import 'package:tv/presentation/bloc/tv_top_rated_cubit.dart';
import 'package:tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/get_watchlists.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_movie_watchlist.dart';
import 'package:tv/domain/usecases/save_tv_watchlist.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:watchlist/presentation/bloc/watchlist_cubit.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // bloc
  locator.registerFactory(
    () => MovieHomeCubit(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator()
    )
  );
  locator.registerFactory(
    () => MovieDetailCubit(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveMovieWatchlist: locator(),
      removeWatchlist: locator(),
    )
  );
  locator.registerFactory(
    () => MovieSearchCubit(
      searchMovies: locator()
    )
  );
  locator.registerFactory(
    () => MoviePopularCubit(
      getPopularMovies: locator(),
    )
  );
  locator.registerFactory(
    () => MovieTopRatedCubit(
      getTopRatedMovies: locator(),
    )
  );
  locator.registerFactory(
    () => TVListCubit(
      getNowPlayingTVs: locator(),
      getPopularTVs: locator(),
      getTopRatedTVs: locator()
    )
  );
  locator.registerFactory(
    () => TVDetailCubit(
      getTVDetail: locator(),
      getTVRecommendations: locator(),
      getWatchListStatus: locator(),
      saveTVWatchlist: locator(),
      removeWatchlist: locator(),
    )
  );
  locator.registerFactory(
    () => TVSearchCubit(
      searchTVs: locator()
    )
  );
  locator.registerFactory(
    () => TVPopularCubit(
      getPopularTVs: locator(),
    )
  );
  locator.registerFactory(
    () => TVTopRatedCubit(
      getTopRatedTVs: locator(),
    )
  );
  locator.registerFactory(
    () => WatchlistCubit(
      getWatchlists: locator(),
    )
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingTVs(locator()));
  locator.registerLazySingleton(() => GetPopularTVs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVs(locator()));
  locator.registerLazySingleton(() => GetTVDetail(locator()));
  locator.registerLazySingleton(() => GetTVRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTVs(locator()));

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
  // locator.registerLazySingleton<MovieRemoteDataSource>(
  //     () => MovieRemoteDataSourceImpl(client: locator(), sslPinningHelper: locator()));
  // locator.registerLazySingleton<TVRemoteDataSource>(
  //     () => TVRemoteDataSourceImpl(client: locator(), sslPinningHelper: locator()));
	locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(ioClient: locator()));
  locator.registerLazySingleton<TVRemoteDataSource>(
      () => TVRemoteDataSourceImpl(ioClient: locator()));
  locator.registerLazySingleton<WatchlistLocalDataSource>(
      () => WatchlistLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  // locator.registerLazySingleton<SslPinningHelper>(() => SslPinningHelper());

  // external
	HttpClient client = HttpClient(context: await globalContext);
	client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
  IOClient ioClient = IOClient(client);
  locator.registerLazySingleton(() => ioClient);
}

Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('certificates/certificates.pem');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  return securityContext;
}
