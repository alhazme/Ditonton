import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTopRatedTVs(mockTVRepository);
  });

  final tTVs = <TV>[];

  test('should get list of tvs from repository', () async {
    // arrange
    when(mockTVRepository.getTopRatedTVs())
        .thenAnswer((_) async => Right(tTVs));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTVs));
  });
}
