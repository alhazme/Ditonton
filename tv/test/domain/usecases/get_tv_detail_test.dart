import 'package:dartz/dartz.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetTVDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVDetail(mockTVRepository);
  });

  const tId = 1;

  test('should get tv detail from the repository', () async {
    // arrange
    when(mockTVRepository.getTVDetail(tId))
        .thenAnswer((_) async => Right(mockedTVDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(mockedTVDetail));
  });
}
