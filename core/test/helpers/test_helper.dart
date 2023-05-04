import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/datasources/watchlist_local_data_source.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/repositories/watchlist_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  MovieRepository,
  TVRepository,
  WatchlistRepository,
  MovieRemoteDataSource,
  TVRemoteDataSource,
  WatchlistLocalDataSource,
  DatabaseHelper,
], customMocks: [
	MockSpec<IOClient>(as: #MockIOClient)
])
void main() {}

class MockNavigatorObserver extends Mock implements NavigatorObserver { }
