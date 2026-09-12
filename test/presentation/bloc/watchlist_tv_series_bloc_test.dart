import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTVSeries])
void main() {
  late MockGetWatchlistTVSeries mockGetWatchlistTVSeries;

  setUp(() {
    mockGetWatchlistTVSeries = MockGetWatchlistTVSeries();
  });

  test('initial state should be WatchlistTVSeriesEmpty', () {
    expect(
      WatchlistTVSeriesBloc(
              getWatchlistTVSeries: mockGetWatchlistTVSeries)
          .state,
      isA<WatchlistTVSeriesEmpty>(),
    );
  });

  blocTest<WatchlistTVSeriesBloc, WatchlistTVSeriesState>(
    'emits [Loading, Loaded] when FetchWatchlistTVSeries succeeds',
    build: () {
      when(mockGetWatchlistTVSeries.execute())
          .thenAnswer((_) async => Right(testTVSeriesList));
      return WatchlistTVSeriesBloc(
          getWatchlistTVSeries: mockGetWatchlistTVSeries);
    },
    act: (bloc) => bloc.add(FetchWatchlistTVSeries()),
    expect: () => [
      WatchlistTVSeriesLoading(),
      WatchlistTVSeriesLoaded(testTVSeriesList),
    ],
  );

  blocTest<WatchlistTVSeriesBloc, WatchlistTVSeriesState>(
    'emits [Loading, Error] when FetchWatchlistTVSeries fails',
    build: () {
      when(mockGetWatchlistTVSeries.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      return WatchlistTVSeriesBloc(
          getWatchlistTVSeries: mockGetWatchlistTVSeries);
    },
    act: (bloc) => bloc.add(FetchWatchlistTVSeries()),
    expect: () => [
      WatchlistTVSeriesLoading(),
      const WatchlistTVSeriesError('Failed'),
    ],
  );
}
