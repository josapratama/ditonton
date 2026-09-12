import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTVSeriesModel = TVSeriesModel(
    backdropPath: 'backdropPath',
    firstAirDate: '2008-01-20',
    genreIds: [18, 80],
    id: 1396,
    name: 'Breaking Bad',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    overview: 'overview',
    popularity: 369.594,
    posterPath: '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
    voteAverage: 8.9,
    voteCount: 11000,
  );

  final tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    firstAirDate: '2008-01-20',
    genreIds: [18, 80],
    id: 1396,
    name: 'Breaking Bad',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    overview: 'overview',
    popularity: 369.594,
    posterPath: '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
    voteAverage: 8.9,
    voteCount: 11000,
  );

  test('should be a subclass of TVSeries entity', () async {
    final result = tTVSeriesModel.toEntity();
    expect(result, tTVSeries);
  });

  test('should return a valid JSON map', () {
    final result = tTVSeriesModel.toJson();
    expect(result['id'], 1396);
    expect(result['name'], 'Breaking Bad');
    expect(result['vote_average'], 8.9);
  });

  test('should create model from JSON correctly', () {
    final json = {
      'backdrop_path': 'backdropPath',
      'first_air_date': '2008-01-20',
      'genre_ids': [18, 80],
      'id': 1396,
      'name': 'Breaking Bad',
      'origin_country': ['US'],
      'original_language': 'en',
      'original_name': 'Breaking Bad',
      'overview': 'overview',
      'popularity': 369.594,
      'poster_path': '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
      'vote_average': 8.9,
      'vote_count': 11000,
    };
    final result = TVSeriesModel.fromJson(json);
    expect(result, tTVSeriesModel);
  });
}
