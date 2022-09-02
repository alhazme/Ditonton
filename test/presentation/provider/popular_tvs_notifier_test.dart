import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:ditonton/presentation/provider/popular_tvs_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import '../../dummy_data/dummy_objects.dart';
import 'popular_tvs_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTVs])
void main() {

  late MockGetPopularTVs mockGetPopularTVs;
  late PopularTVsNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTVs = MockGetPopularTVs();
    notifier = PopularTVsNotifier(getPopularTVs: mockGetPopularTVs)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTVs.execute())
        .thenAnswer((_) async => Right(mockedTVList));
    // act
    notifier.fetchPopularTVs();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tvss data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTVs.execute())
        .thenAnswer((_) async => Right(mockedTVList));
    // act
    await notifier.fetchPopularTVs();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvs, mockedTVList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTVs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTVs();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}