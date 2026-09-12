import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TVSeriesRepositoryImpl repository;
  late MockTVSeriesRemoteDataSource mockRemoteDataSource;
  late MockTVSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVSeriesRemoteDataSource();
    mockLocalDataSource = MockTVSeriesLocalDataSource();
    repository = TVSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTVSeriesModel = TVSeriesModel(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    firstAirDate: '2008-01-20',
    genreIds: [18, 80],
    id: 1396,
    name: 'Breaking Bad',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    overview:
        'When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer.',
    popularity: 369.594,
    posterPath: '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
    voteAverage: 8.9,
    voteCount: 11000,
  );

  final tTVSeries = TVSeries(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    firstAirDate: '2008-01-20',
    genreIds: [18, 80],
    id: 1396,
    name: 'Breaking Bad',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    overview:
        'When Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer.',
    popularity: 369.594,
    posterPath: '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
    voteAverage: 8.9,
    voteCount: 11000,
  );

  final tTVSeriesModelList = <TVSeriesModel>[tTVSeriesModel];
  final tTVSeriesList = <TVSeries>[tTVSeries];

  group('On Air Tv Series', () {
    test('should return remote data when call to remote data source is success',
        () async {
      when(mockRemoteDataSource.getOnAirTVSeries())
          .thenAnswer((_) async => tTVSeriesModelList);
      final result = await repository.getOnAirTVSeries();
      verify(mockRemoteDataSource.getOnAirTVSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVSeriesList);
    });

    test('should return ServerFailure when call to remote data source fails',
        () async {
      when(mockRemoteDataSource.getOnAirTVSeries())
          .thenThrow(ServerException());
      final result = await repository.getOnAirTVSeries();
      expect(result, Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is not connected',
        () async {
      when(mockRemoteDataSource.getOnAirTVSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getOnAirTVSeries();
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Popular Tv Series', () {
    test('should return tv series list when call to data source is success',
        () async {
      when(mockRemoteDataSource.getPopularTVSeries())
          .thenAnswer((_) async => tTVSeriesModelList);
      final result = await repository.getPopularTVSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getPopularTVSeries())
          .thenThrow(ServerException());
      final result = await repository.getPopularTVSeries();
      expect(result, Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is not connected',
        () async {
      when(mockRemoteDataSource.getPopularTVSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getPopularTVSeries();
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Tv Series', () {
    test('should return tv series list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.getTopRatedTVSeries())
          .thenAnswer((_) async => tTVSeriesModelList);
      final result = await repository.getTopRatedTVSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTopRatedTVSeries())
          .thenThrow(ServerException());
      final result = await repository.getTopRatedTVSeries();
      expect(result, Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is not connected',
        () async {
      when(mockRemoteDataSource.getTopRatedTVSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTopRatedTVSeries();
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Series Detail', () {
    final tId = 1396;
    final tTVSeriesDetail = TVSeriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_series_detail.json')));

    test(
        'should return tv series data when call to remote data source is success',
        () async {
      when(mockRemoteDataSource.getTVSeriesDetail(tId))
          .thenAnswer((_) async => tTVSeriesDetail);
      final result = await repository.getTVSeriesDetail(tId);
      verify(mockRemoteDataSource.getTVSeriesDetail(tId));
      expect(result, equals(Right(tTVSeriesDetail.toEntity())));
    });

    test('should return Server Failure when call to remote data source fails',
        () async {
      when(mockRemoteDataSource.getTVSeriesDetail(tId))
          .thenThrow(ServerException());
      final result = await repository.getTVSeriesDetail(tId);
      expect(result, Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is not connected',
        () async {
      when(mockRemoteDataSource.getTVSeriesDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTVSeriesDetail(tId);
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Series Recommendations', () {
    final tId = 1396;

    test('should return data when the call is successful', () async {
      when(mockRemoteDataSource.getTVSeriesRecommendations(tId))
          .thenAnswer((_) async => tTVSeriesModelList);
      final result = await repository.getTVSeriesRecommendations(tId);
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVSeriesList);
    });

    test('should return ServerFailure when call fails', () async {
      when(mockRemoteDataSource.getTVSeriesRecommendations(tId))
          .thenThrow(ServerException());
      final result = await repository.getTVSeriesRecommendations(tId);
      expect(result, Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is not connected',
        () async {
      when(mockRemoteDataSource.getTVSeriesRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTVSeriesRecommendations(tId);
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Search Tv Series', () {
    final tQuery = 'breaking bad';

    test('should return tv series list when call to data source is success',
        () async {
      when(mockRemoteDataSource.searchTVSeries(tQuery))
          .thenAnswer((_) async => tTVSeriesModelList);
      final result = await repository.searchTVSeries(tQuery);
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.searchTVSeries(tQuery))
          .thenThrow(ServerException());
      final result = await repository.searchTVSeries(tQuery);
      expect(result, Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is not connected',
        () async {
      when(mockRemoteDataSource.searchTVSeries(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.searchTVSeries(tQuery);
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      when(mockLocalDataSource.insertWatchlist(testTVSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlist(testTVSeriesDetail);
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(mockLocalDataSource.insertWatchlist(testTVSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlist(testTVSeriesDetail);
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      when(mockLocalDataSource.removeWatchlist(testTVSeriesTable))
          .thenAnswer((_) async => 'Removed from Watchlist');
      final result = await repository.removeWatchlist(testTVSeriesDetail);
      expect(result, Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(mockLocalDataSource.removeWatchlist(testTVSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlist(testTVSeriesDetail);
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      when(mockLocalDataSource.getTVSeriesById(1))
          .thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlist(1);
      expect(result, false);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TVSeries', () async {
      when(mockLocalDataSource.getWatchlistTVSeries())
          .thenAnswer((_) async => [testTVSeriesTable]);
      final result = await repository.getWatchlistTVSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTVSeries]);
    });
  });
}
