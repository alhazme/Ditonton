import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/utils/failure.dart';

abstract class TVRepository {
  Future<Either<Failure, List<TV>>> getNowPlayingTVs();
  Future<Either<Failure, List<TV>>> getPopularTVs();
  Future<Either<Failure, List<TV>>> getTopRatedTVs();
  Future<Either<Failure, TVDetail>> getTVDetail(int id);
  Future<Either<Failure, List<TV>>> getTVRecommendations(int id);
  Future<Either<Failure, List<TV>>> searchTVs(String query);
}
