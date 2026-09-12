import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_on_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([GetOnAirTVSeries, GetPopularTVSeries, GetTopRatedTVSeries])
void main() {
  late TVSeriesListNotifier provider;
  late MockGetOnAirTVSeries mockGetOnAirTVSeries;
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnAirTVSeries = MockGetOnAirTVSeries();
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    provider = TVSeriesListNotifier(
      getOnAirTVSeries: mockGetOnAirTVSeries,
      getPopularTVSeries: mockGetPopularTVSeries,
      getTopRatedTVSeries: mockGetTopRatedTVSeries,
    )..addListener(() {
        listenerCallCount += 1;
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

  group('on air tv series', () {
    test('initialState should be Empty', () {
      expect(provider.onAirState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      when(mockGetOnAirTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      provider.fetchOnAirTVSeries();
      verify(mockGetOnAirTVSeries.execute());
    });

    test('should change state to Loading when usecase is called', () {
      when(mockGetOnAirTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      provider.fetchOnAirTVSeries();
      expect(provider.onAirState, RequestState.Loading);
    });

    test('should change tv series when data is gotten successfully', () async {
      when(mockGetOnAirTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      await provider.fetchOnAirTVSeries();
      expect(provider.onAirState, RequestState.Loaded);
      expect(provider.onAirTVSeries, tTVSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetOnAirTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      await provider.fetchOnAirTVSeries();
      expect(provider.onAirState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv series', () {
    test('should change state to Loading when usecase is called', () async {
      when(mockGetPopularTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      provider.fetchPopularTVSeries();
      expect(provider.popularTVSeriesState, RequestState.Loading);
    });

    test('should change data when data is gotten successfully', () async {
      when(mockGetPopularTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      await provider.fetchPopularTVSeries();
      expect(provider.popularTVSeriesState, RequestState.Loaded);
      expect(provider.popularTVSeries, tTVSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetPopularTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      await provider.fetchPopularTVSeries();
      expect(provider.popularTVSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv series', () {
    test('should change state to Loading when usecase is called', () async {
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      provider.fetchTopRatedTVSeries();
      expect(provider.topRatedTVSeriesState, RequestState.Loading);
    });

    test('should change data when data is gotten successfully', () async {
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Right(tTVSeriesList));
      await provider.fetchTopRatedTVSeries();
      expect(provider.topRatedTVSeriesState, RequestState.Loaded);
      expect(provider.topRatedTVSeries, tTVSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetTopRatedTVSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      await provider.fetchTopRatedTVSeries();
      expect(provider.topRatedTVSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
