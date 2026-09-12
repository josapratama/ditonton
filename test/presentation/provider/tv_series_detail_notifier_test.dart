import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVSeriesDetail,
  GetTVSeriesRecommendations,
  GetWatchListStatusTVSeries,
  SaveWatchlistTVSeries,
  RemoveWatchlistTVSeries,
])
void main() {
  late TVSeriesDetailNotifier provider;
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetTVSeriesRecommendations mockGetTVSeriesRecommendations;
  late MockGetWatchListStatusTVSeries mockGetWatchlistStatus;
  late MockSaveWatchlistTVSeries mockSaveWatchlist;
  late MockRemoveWatchlistTVSeries mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetTVSeriesRecommendations = MockGetTVSeriesRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTVSeries();
    mockSaveWatchlist = MockSaveWatchlistTVSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTVSeries();
    provider = TVSeriesDetailNotifier(
      getTVSeriesDetail: mockGetTVSeriesDetail,
      getTVSeriesRecommendations: mockGetTVSeriesRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;
  final tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    firstAirDate: '2008-01-20',
    genreIds: [18],
    id: 1,
    name: 'name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 8.9,
    voteCount: 100,
  );
  final tTVSeriesList = <TVSeries>[tTVSeries];

  void arrangeUsecase() {
    when(mockGetTVSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(testTVSeriesDetail));
    when(mockGetTVSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTVSeriesList));
  }

  group('Get Tv Series Detail', () {
    test('should get data from the usecase', () async {
      arrangeUsecase();
      await provider.fetchTVSeriesDetail(tId);
      verify(mockGetTVSeriesDetail.execute(tId));
      verify(mockGetTVSeriesRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      arrangeUsecase();
      provider.fetchTVSeriesDetail(tId);
      expect(provider.tvSeriesState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv series when data is gotten successfully', () async {
      arrangeUsecase();
      await provider.fetchTVSeriesDetail(tId);
      expect(provider.tvSeriesState, RequestState.Loaded);
      expect(provider.tvSeries, testTVSeriesDetail);
      expect(listenerCallCount, 3);
    });

    test(
        'should change recommendation tv series when data is gotten successfully',
        () async {
      arrangeUsecase();
      await provider.fetchTVSeriesDetail(tId);
      expect(provider.tvSeriesState, RequestState.Loaded);
      expect(provider.tvSeriesRecommendations, tTVSeriesList);
    });
  });

  group('Get Tv Series Recommendations', () {
    test('should update recommendation state when data is gotten successfully',
        () async {
      arrangeUsecase();
      await provider.fetchTVSeriesDetail(tId);
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvSeriesRecommendations, tTVSeriesList);
    });

    test('should update error message when recommendation request fails',
        () async {
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVSeriesDetail));
      when(mockGetTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      await provider.fetchTVSeriesDetail(tId);
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      await provider.loadWatchlistStatus(1);
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      when(mockSaveWatchlist.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => true);
      await provider.addWatchlist(testTVSeriesDetail);
      verify(mockSaveWatchlist.execute(testTVSeriesDetail));
    });

    test('should execute remove watchlist when function called', () async {
      when(mockRemoveWatchlist.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      await provider.removeFromWatchlist(testTVSeriesDetail);
      verify(mockRemoveWatchlist.execute(testTVSeriesDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      when(mockSaveWatchlist.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => true);
      await provider.addWatchlist(testTVSeriesDetail);
      verify(mockGetWatchlistStatus.execute(testTVSeriesDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      when(mockSaveWatchlist.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      await provider.addWatchlist(testTVSeriesDetail);
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVSeriesList));
      await provider.fetchTVSeriesDetail(tId);
      expect(provider.tvSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
