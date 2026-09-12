import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Action');

  final tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/backdrop.jpg',
    budget: 1000000,
    genres: [tGenreModel],
    homepage: 'https://example.com',
    id: 1,
    imdbId: 'tt1234567',
    originalLanguage: 'en',
    originalTitle: 'Original Title',
    overview: 'Overview text',
    popularity: 100.0,
    posterPath: '/poster.jpg',
    releaseDate: '2021-01-01',
    revenue: 5000000,
    runtime: 120,
    status: 'Released',
    tagline: 'A tagline',
    title: 'Title',
    video: false,
    voteAverage: 7.5,
    voteCount: 1000,
  );

  final tJson = {
    'adult': false,
    'backdrop_path': '/backdrop.jpg',
    'budget': 1000000,
    'genres': [
      {'id': 1, 'name': 'Action'}
    ],
    'homepage': 'https://example.com',
    'id': 1,
    'imdb_id': 'tt1234567',
    'original_language': 'en',
    'original_title': 'Original Title',
    'overview': 'Overview text',
    'popularity': 100.0,
    'poster_path': '/poster.jpg',
    'release_date': '2021-01-01',
    'revenue': 5000000,
    'runtime': 120,
    'status': 'Released',
    'tagline': 'A tagline',
    'title': 'Title',
    'video': false,
    'vote_average': 7.5,
    'vote_count': 1000,
  };

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview text',
    posterPath: '/poster.jpg',
    releaseDate: '2021-01-01',
    runtime: 120,
    title: 'Title',
    voteAverage: 7.5,
    voteCount: 1000,
  );

  group('MovieDetailResponse', () {
    test('fromJson should return a valid model', () {
      final result = MovieDetailResponse.fromJson(tJson);
      expect(result, tMovieDetailResponse);
    });

    test('toJson should return correct JSON map', () {
      final result = tMovieDetailResponse.toJson();
      expect(result, tJson);
    });

    test('toEntity should return a MovieDetail entity', () {
      final result = tMovieDetailResponse.toEntity();
      expect(result, tMovieDetail);
    });

    test('fromJson handles null backdropPath and imdbId', () {
      final json = Map<String, dynamic>.from(tJson);
      json['backdrop_path'] = null;
      json['imdb_id'] = null;
      final result = MovieDetailResponse.fromJson(json);
      expect(result.backdropPath, isNull);
      expect(result.imdbId, isNull);
    });

    test('props should contain all fields', () {
      expect(tMovieDetailResponse.props, isNotEmpty);
      expect(tMovieDetailResponse.props.length, 21);
    });
  });
}
