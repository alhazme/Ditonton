import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/datasources/watchlist_local_data_source.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/repositories/watchlist_repository.dart';
import 'package:core/helper/ssl_pinning.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

@GenerateMocks([
  MovieRepository,
  TVRepository,
  WatchlistRepository,
  MovieRemoteDataSource,
  TVRemoteDataSource,
  WatchlistLocalDataSource,
  DatabaseHelper,
  SslPinningHelper
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}

class MockNavigatorObserver extends Mock implements NavigatorObserver { }
