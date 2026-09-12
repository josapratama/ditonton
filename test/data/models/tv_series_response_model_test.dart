import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
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

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_on_the_air.json'));
      // act
      final result = TVSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result.tvSeriesList, [tTVSeriesModel]);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final tTVSeriesResponse = TVSeriesResponse(
        tvSeriesList: [tTVSeriesModel],
      );
      // act
      final result = tTVSeriesResponse.toJson();
      // assert
      final expectedJsonList = {
        "results": [tTVSeriesModel.toJson()],
      };
      expect(result, expectedJsonList);
    });
  });
}
