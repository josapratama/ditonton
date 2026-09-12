import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  const tJson = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  final tMovieWatchlist = Movie.watchlist(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('MovieTable', () {
    test('fromEntity should create MovieTable from MovieDetail', () {
      final result = MovieTable.fromEntity(testMovieDetail);
      expect(result.id, testMovieDetail.id);
      expect(result.title, testMovieDetail.title);
      expect(result.posterPath, testMovieDetail.posterPath);
      expect(result.overview, testMovieDetail.overview);
    });

    test('fromMap should create MovieTable from map', () {
      final result = MovieTable.fromMap(tJson);
      expect(result, tMovieTable);
    });

    test('toJson should return correct map', () {
      final result = tMovieTable.toJson();
      expect(result, tJson);
    });

    test('toEntity should return a Movie watchlist entity', () {
      final result = tMovieTable.toEntity();
      expect(result, tMovieWatchlist);
    });

    test('props should contain all fields', () {
      expect(tMovieTable.props, [1, 'title', 'posterPath', 'overview']);
    });
  });
}
