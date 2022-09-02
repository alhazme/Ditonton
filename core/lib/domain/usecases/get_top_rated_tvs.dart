import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';

class GetTopRatedTVs {
  final TVRepository repository;

  GetTopRatedTVs(this.repository);

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getTopRatedTVs();
  }
}
