import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTVSeries])
void main() {
  late TopRatedTVSeriesNotifier notifier;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    notifier =
        TopRatedTVSeriesNotifier(getTopRatedTVSeries: mockGetTopRatedTVSeries)
          ..addListener(() {
            listenerCallCount++;
          });
  });

  final tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    firstAirDate: '2008-01-20',
    genreIds: [18, 80],
    id: 1,
    name: 'Breaking Bad',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    overview: 'overview',
    popularity: 369.594,
    posterPath: '/poster.jpg',
    voteAverage: 8.9,
    voteCount: 11000,
  );
  final tTVSeriesList = <TVSeries>[tTVSeries];

  group('get top rated tv series', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      notifier.fetchTopRatedTVSeries();
      expect(notifier.state, RequestState.Loading);
    });

    test('should change data when data is gotten successfully', () async {
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      await notifier.fetchTopRatedTVSeries();
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.tvSeries, tTVSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      await notifier.fetchTopRatedTVSeries();
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
