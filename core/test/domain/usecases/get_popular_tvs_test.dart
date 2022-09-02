import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_popular_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetPopularTVs(mockTVRepository);
  });

  final tTVs = <TV>[];

  group('GetPopularTVs Tests', () {
    group('execute', () {
      test(
          'should get list of tvs from the repository when execute function is called',
              () async {
            // arrange
            when(mockTVRepository.getPopularTVs())
                .thenAnswer((_) async => Right(tTVs));
            // act
            final result = await usecase.execute();
            // assert
            expect(result, Right(tTVs));
          });
    });
  });
}
