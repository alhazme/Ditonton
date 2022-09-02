import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_now_playing_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetNowPlayingTVs(mockTVRepository);
  });

  final tTVs = <TV>[];

  test('should get list of tvs from the repository', () async {
    // arrange
    when(mockTVRepository.getNowPlayingTVs())
        .thenAnswer((_) async => Right(tTVs));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTVs));
  });
}
