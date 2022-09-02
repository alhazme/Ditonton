import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTopRatedTVs {
  final TVRepository repository;

  GetTopRatedTVs(this.repository);

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getTopRatedTVs();
  }
}
