import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVSeriesDetail,
  GetTVSeriesRecommendations,
  GetWatchListStatusTVSeries,
  SaveWatchlistTVSeries,
  RemoveWatchlistTVSeries,
])
void main() {
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetTVSeriesRecommendations mockGetTVSeriesRecommendations;
  late MockGetWatchListStatusTVSeries mockGetWatchlistStatus;
  late MockSaveWatchlistTVSeries mockSaveWatchlist;
  late MockRemoveWatchlistTVSeries mockRemoveWatchlist;

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

  TVSeriesDetailBloc buildBloc() => TVSeriesDetailBloc(
    getTVSeriesDetail: mockGetTVSeriesDetail,
    getTVSeriesRecommendations: mockGetTVSeriesRecommendations,
    getWatchListStatus: mockGetWatchlistStatus,
    saveWatchlist: mockSaveWatchlist,
    removeWatchlist: mockRemoveWatchlist,
  );

  setUp(() {
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetTVSeriesRecommendations = MockGetTVSeriesRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTVSeries();
    mockSaveWatchlist = MockSaveWatchlistTVSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTVSeries();
  });

  test('initial state should be TVSeriesDetailState.initial()', () {
    expect(buildBloc().state, TVSeriesDetailState.initial());
  });

  group('FetchTVSeriesDetail', () {
    void arrangeUsecase() {
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVSeriesDetail));
      when(mockGetTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVSeriesList));
    }

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits loading then loaded state when fetch succeeds',
      build: () {
        arrangeUsecase();
        return buildBloc();
      },
      act: (bloc) => bloc.add(FetchTVSeriesDetail(tId)),
      expect: () => [
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.loading,
        ),
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.loading,
          tvSeries: testTVSeriesDetail,
          recommendationState: RequestState.loading,
        ),
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTVSeriesDetail,
          recommendations: tTVSeriesList,
          recommendationState: RequestState.loaded,
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits error state when FetchTVSeriesDetail fails',
      build: () {
        when(mockGetTVSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTVSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTVSeriesList));
        return buildBloc();
      },
      act: (bloc) => bloc.add(FetchTVSeriesDetail(tId)),
      expect: () => [
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.loading,
        ),
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits recommendation error when recommendations fail',
      build: () {
        when(mockGetTVSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVSeriesDetail));
        when(mockGetTVSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(FetchTVSeriesDetail(tId)),
      expect: () => [
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.loading,
        ),
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.loading,
          tvSeries: testTVSeriesDetail,
          recommendationState: RequestState.loading,
        ),
        TVSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.loading,
          tvSeries: testTVSeriesDetail,
          recommendationState: RequestState.error,
          message: 'Failed',
        ),
      ],
    );
  });

  group('LoadTVSeriesWatchlistStatus', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits isAddedToWatchlist true when status is true',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadTVSeriesWatchlistStatus(tId)),
      expect: () => [
        TVSeriesDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
    );
  });

  group('AddTVSeriesToWatchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits watchlistMessage and updated status when add succeeds',
      build: () {
        when(mockSaveWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
            .thenAnswer((_) async => true);
        return buildBloc();
      },
      act: (bloc) => bloc.add(AddTVSeriesToWatchlist(testTVSeriesDetail)),
      expect: () => [
        TVSeriesDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        TVSeriesDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits watchlistMessage error when add fails',
      build: () {
        when(mockSaveWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
            .thenAnswer((_) async => false);
        return buildBloc();
      },
      act: (bloc) => bloc.add(AddTVSeriesToWatchlist(testTVSeriesDetail)),
      expect: () => [
        TVSeriesDetailState.initial().copyWith(watchlistMessage: 'Failed'),
        // isAddedToWatchlist stays false (same as initial) so equatable dedupes
      ],
    );
  });

  group('RemoveTVSeriesFromWatchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits watchlistMessage and updated status when remove succeeds',
      build: () {
        when(mockRemoveWatchlist.execute(testTVSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
            .thenAnswer((_) async => false);
        return buildBloc();
      },
      act: (bloc) => bloc.add(RemoveTVSeriesFromWatchlist(testTVSeriesDetail)),
      expect: () => [
        TVSeriesDetailState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
        ),
        // isAddedToWatchlist stays false (same as initial) so equatable dedupes
      ],
    );
  });
}
