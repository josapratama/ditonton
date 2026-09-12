import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeasonModel = SeasonModel(
    airDate: '2008-01-20',
    episodeCount: 7,
    id: 3572,
    name: 'Season 1',
    overview: 'Season overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  const tJson = {
    'air_date': '2008-01-20',
    'episode_count': 7,
    'id': 3572,
    'name': 'Season 1',
    'overview': 'Season overview',
    'poster_path': '/poster.jpg',
    'season_number': 1,
  };

  final tEntity = Season(
    airDate: '2008-01-20',
    episodeCount: 7,
    id: 3572,
    name: 'Season 1',
    overview: 'Season overview',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  group('SeasonModel', () {
    test('fromJson should return a valid model', () {
      final result = SeasonModel.fromJson(tJson);
      expect(result, tSeasonModel);
    });

    test('toJson should return a correct JSON map', () {
      final result = tSeasonModel.toJson();
      expect(result, tJson);
    });

    test('toEntity should return a Season entity', () {
      final result = tSeasonModel.toEntity();
      expect(result, tEntity);
    });

    test('fromJson handles null airDate and posterPath', () {
      final json = {
        'air_date': null,
        'episode_count': 7,
        'id': 3572,
        'name': 'Season 1',
        'overview': 'Season overview',
        'poster_path': null,
        'season_number': 1,
      };
      final result = SeasonModel.fromJson(json);
      expect(result.airDate, isNull);
      expect(result.posterPath, isNull);
    });

    test('props should match all fields', () {
      expect(tSeasonModel.props,
          ['2008-01-20', 7, 3572, 'Season 1', 'Season overview', '/poster.jpg', 1]);
    });
  });
}
