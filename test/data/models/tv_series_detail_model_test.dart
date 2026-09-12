import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Drama');
  const tSeasonModel = SeasonModel(
    airDate: '2008-01-20',
    episodeCount: 7,
    id: 3572,
    name: 'Season 1',
    overview: 'overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  final tResponse = TVSeriesDetailResponse(
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2008-01-20',
    genres: [tGenreModel],
    id: 1396,
    name: 'Breaking Bad',
    numberOfEpisodes: 62,
    numberOfSeasons: 5,
    originalName: 'Breaking Bad',
    overview: 'A chemistry teacher turns to cooking meth.',
    popularity: 369.594,
    posterPath: '/poster.jpg',
    seasons: [tSeasonModel],
    status: 'Ended',
    tagline: 'All Hail the King',
    type: 'Scripted',
    voteAverage: 8.9,
    voteCount: 11000,
  );

  final tJson = {
    'backdrop_path': '/backdrop.jpg',
    'first_air_date': '2008-01-20',
    'genres': [
      {'id': 1, 'name': 'Drama'},
    ],
    'id': 1396,
    'name': 'Breaking Bad',
    'number_of_episodes': 62,
    'number_of_seasons': 5,
    'original_name': 'Breaking Bad',
    'overview': 'A chemistry teacher turns to cooking meth.',
    'popularity': 369.594,
    'poster_path': '/poster.jpg',
    'seasons': [
      {
        'air_date': '2008-01-20',
        'episode_count': 7,
        'id': 3572,
        'name': 'Season 1',
        'overview': 'overview',
        'poster_path': '/poster.jpg',
        'season_number': 1,
      },
    ],
    'status': 'Ended',
    'tagline': 'All Hail the King',
    'type': 'Scripted',
    'vote_average': 8.9,
    'vote_count': 11000,
  };

  final tEntity = TVSeriesDetail(
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2008-01-20',
    genres: [Genre(id: 1, name: 'Drama')],
    id: 1396,
    name: 'Breaking Bad',
    numberOfEpisodes: 62,
    numberOfSeasons: 5,
    originalName: 'Breaking Bad',
    overview: 'A chemistry teacher turns to cooking meth.',
    popularity: 369.594,
    posterPath: '/poster.jpg',
    seasons: [
      Season(
        airDate: '2008-01-20',
        episodeCount: 7,
        id: 3572,
        name: 'Season 1',
        overview: 'overview',
        posterPath: '/poster.jpg',
        seasonNumber: 1,
      ),
    ],
    status: 'Ended',
    tagline: 'All Hail the King',
    type: 'Scripted',
    voteAverage: 8.9,
    voteCount: 11000,
  );

  group('TVSeriesDetailResponse', () {
    test('fromJson should return a valid model', () {
      final result = TVSeriesDetailResponse.fromJson(tJson);
      expect(result, tResponse);
    });

    test('toJson should return correct JSON map', () {
      final result = tResponse.toJson();
      expect(result, tJson);
    });

    test('toEntity should return a TVSeriesDetail entity', () {
      final result = tResponse.toEntity();
      expect(result, tEntity);
    });

    test(
      'fromJson handles null backdropPath and uses empty string for null posterPath',
      () {
        final json = Map<String, dynamic>.from(tJson);
        json['backdrop_path'] = null;
        json['poster_path'] = null;
        json['first_air_date'] = null;
        final result = TVSeriesDetailResponse.fromJson(json);
        expect(result.backdropPath, isNull);
        expect(result.posterPath, '');
        expect(result.firstAirDate, '');
      },
    );

    test('props should contain all fields', () {
      expect(tResponse.props, isNotEmpty);
      expect(tResponse.props.length, 17);
    });
  });
}
