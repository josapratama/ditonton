import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTVSeries])
void main() {
  late WatchlistTVSeriesNotifier notifier;
  late MockGetWatchlistTVSeries mockGetWatchlistTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTVSeries = MockGetWatchlistTVSeries();
    notifier = WatchlistTVSeriesNotifier(
        getWatchlistTVSeries: mockGetWatchlistTVSeries)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  group('get watchlist tv series', () {
    test('should change state to Loading when usecase is called', () async {
      when(mockGetWatchlistTVSeries.execute())
          .thenAnswer((_) async => Right(testTVSeriesList));
      notifier.fetchWatchlistTVSeries();
      expect(notifier.watchlistState, RequestState.Loading);
    });

    test('should change data when data is gotten successfully', () async {
      when(mockGetWatchlistTVSeries.execute())
          .thenAnswer((_) async => Right(testTVSeriesList));
      await notifier.fetchWatchlistTVSeries();
      expect(notifier.watchlistState, RequestState.Loaded);
      expect(notifier.watchlistTVSeries, testTVSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetWatchlistTVSeries.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      await notifier.fetchWatchlistTVSeries();
      expect(notifier.watchlistState, RequestState.Error);
      expect(notifier.message, 'Failed');
      expect(listenerCallCount, 2);
    });
  });
}
