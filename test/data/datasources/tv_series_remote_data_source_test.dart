import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TVSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On Air TV Series', () {
    final tTVSeriesList = TVSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_on_the_air.json')))
        .tvSeriesList;

    test('should return list of TVSeriesModel when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_on_the_air.json'), 200));
      final result = await dataSource.getOnAirTVSeries();
      expect(result, equals(tTVSeriesList));
    });

    test('should throw a ServerException when the response code is 404',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getOnAirTVSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV Series', () {
    final tTVSeriesList = TVSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_on_the_air.json')))
        .tvSeriesList;

    test('should return list of TVSeriesModel when response is success (200)',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_on_the_air.json'), 200));
      final result = await dataSource.getPopularTVSeries();
      expect(result, tTVSeriesList);
    });

    test('should throw a ServerException when the response code is 404',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getPopularTVSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV Series', () {
    final tTVSeriesList = TVSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_on_the_air.json')))
        .tvSeriesList;

    test('should return list of TVSeriesModel when response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_on_the_air.json'), 200));
      final result = await dataSource.getTopRatedTVSeries();
      expect(result, tTVSeriesList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTopRatedTVSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Series Detail', () {
    final tId = 1396;
    final tTVSeriesDetail = TVSeriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_series_detail.json')));

    test('should return tv series detail when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_series_detail.json'), 200));
      final result = await dataSource.getTVSeriesDetail(tId);
      expect(result, equals(tTVSeriesDetail));
    });

    test('should throw Server Exception when the response code is 404',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTVSeriesDetail(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Series Recommendations', () {
    final tTVSeriesList = TVSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_on_the_air.json')))
        .tvSeriesList;
    final tId = 1396;

    test('should return list of TVSeriesModel when the response code is 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_on_the_air.json'), 200));
      final result = await dataSource.getTVSeriesRecommendations(tId);
      expect(result, equals(tTVSeriesList));
    });

    test('should throw Server Exception when the response code is 404',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTVSeriesRecommendations(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search TV Series', () {
    final tSearchResult = TVSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/search_breaking_bad.json')))
        .tvSeriesList;
    final tQuery = 'Breaking Bad';

    test('should return list of tv series when response code is 200', () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_breaking_bad.json'), 200));
      final result = await dataSource.searchTVSeries(tQuery);
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.searchTVSeries(tQuery);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
