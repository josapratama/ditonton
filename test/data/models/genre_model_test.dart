import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'Action');
  final tGenre = Genre(id: 1, name: 'Action');
  const tJson = {'id': 1, 'name': 'Action'};

  group('GenreModel', () {
    test('fromJson should return a valid model', () {
      final result = GenreModel.fromJson(tJson);
      expect(result, tGenreModel);
    });

    test('toJson should return a correct JSON map', () {
      final result = tGenreModel.toJson();
      expect(result, tJson);
    });

    test('toEntity should return a Genre entity', () {
      final result = tGenreModel.toEntity();
      expect(result, tGenre);
    });

    test('props should contain id and name', () {
      expect(tGenreModel.props, [1, 'Action']);
    });
  });
}
