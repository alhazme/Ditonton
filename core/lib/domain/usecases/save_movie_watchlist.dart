import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/repositories/watchlist_repository.dart';

class SaveMovieWatchlist {
  final WatchlistRepository repository;

  SaveMovieWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveMovieWatchlist(movie);
  }
}
