import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  final tId = 1;
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  MovieDetailBloc buildBloc() => MovieDetailBloc(
    getMovieDetail: mockGetMovieDetail,
    getMovieRecommendations: mockGetMovieRecommendations,
    getWatchListStatus: mockGetWatchlistStatus,
    saveWatchlist: mockSaveWatchlist,
    removeWatchlist: mockRemoveWatchlist,
  );

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
  });

  test('initial state should be MovieDetailState.initial()', () {
    expect(buildBloc().state, MovieDetailState.initial());
  });

  group('FetchMovieDetail', () {
    void arrangeUsecase() {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovieList));
    }

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits loading then loaded state when fetch succeeds',
      build: () {
        arrangeUsecase();
        return buildBloc();
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(movieState: RequestState.loading),
        MovieDetailState.initial().copyWith(
          movieState: RequestState.loading,
          movie: testMovieDetail,
          recommendationState: RequestState.loading,
        ),
        MovieDetailState.initial().copyWith(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendations: tMovieList,
          recommendationState: RequestState.loaded,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits error state when FetchMovieDetail fails',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovieList));
        return buildBloc();
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(movieState: RequestState.loading),
        MovieDetailState.initial().copyWith(
          movieState: RequestState.error,
          message: 'Server Failure',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits recommendation error when recommendations fail',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(movieState: RequestState.loading),
        MovieDetailState.initial().copyWith(
          movieState: RequestState.loading,
          movie: testMovieDetail,
          recommendationState: RequestState.loading,
        ),
        MovieDetailState.initial().copyWith(
          movieState: RequestState.loading,
          movie: testMovieDetail,
          recommendationState: RequestState.error,
          message: 'Failed',
        ),
      ],
    );
  });

  group('LoadMovieWatchlistStatus', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits isAddedToWatchlist true when status is true',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadMovieWatchlistStatus(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
    );
  });

  group('AddMovieToWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits watchlistMessage and updated status when add succeeds',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return buildBloc();
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits watchlistMessage error when add fails',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return buildBloc();
      },
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(watchlistMessage: 'Failed'),
        // isAddedToWatchlist stays false (same as initial) so equatable dedupes
      ],
    );
  });

  group('RemoveMovieFromWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits watchlistMessage and updated status when remove succeeds',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return buildBloc();
      },
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
        ),
        // isAddedToWatchlist stays false (same as initial) so equatable dedupes
      ],
    );
  });
}
