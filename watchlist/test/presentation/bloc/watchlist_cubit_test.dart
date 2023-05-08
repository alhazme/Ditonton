import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/domain/usecases/get_watchlists.dart';
import 'package:watchlist/presentation/bloc/watchlist_cubit.dart';
import 'package:watchlist/presentation/bloc/watchlist_state.dart';
import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'watchlist_cubit_test.mocks.dart';

@GenerateMocks([
  GetWatchlists,
])
void main() {
  late WatchlistCubit watchlistCubit;
  late WatchlistState watchlistState;
  late MockGetWatchlists mockGetWatchlists;

  setUp(() {
    mockGetWatchlists = MockGetWatchlists();
    watchlistCubit = WatchlistCubit(
        getWatchlists: mockGetWatchlists
    );
    watchlistState = const WatchlistState(
      message: "",
      watchlistState: RequestState.Empty,
      watchlists: <Watchlist>[],
    );
  });

  test('Initial state should be equal to default WatchlistState', () {
    expect(watchlistCubit.state, watchlistState);
  });

  blocTest<WatchlistCubit, WatchlistState>(
    'Should emit error when fetchWatchlists is error',
    build: () {
      when(mockGetWatchlists.execute())
          .thenAnswer((_) async => const Left(ServerFailure('failed fetchWatchlists')));
      return watchlistCubit;
    },
    act: (cubit) => cubit.fetchWatchlists(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const WatchlistState(
        message: '',
        watchlistState: RequestState.Loading,
        watchlists: <Watchlist>[],
      ),
      const WatchlistState(
        message: 'failed fetchWatchlists',
        watchlistState: RequestState.Error,
        watchlists: <Watchlist>[],
      ),
    ],
  );

  blocTest<WatchlistCubit, WatchlistState>(
    'Should emit success when fetchWatchlists is success',
    build: () {
      when(mockGetWatchlists.execute())
          .thenAnswer((_) async => Right(mockedWatchlists));
      return watchlistCubit;
    },
    act: (cubit) => cubit.fetchWatchlists(),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      const WatchlistState(
        message: '',
        watchlistState: RequestState.Loading,
        watchlists: <Watchlist>[],
      ),
      WatchlistState(
        message: '',
        watchlistState: RequestState.Loaded,
        watchlists: mockedWatchlists,
      ),
    ],
  );
}