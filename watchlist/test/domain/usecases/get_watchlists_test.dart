import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/usecases/get_watchlists.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlists usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = GetWatchlists(mockWatchlistRepository);
  });

  test('should get list of movies and tvs from the repository', () async {
    // arrange
    when(mockWatchlistRepository.getWatchlists())
        .thenAnswer((_) async => Right(mockedWatchlists));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(mockedWatchlists));
  });
}
