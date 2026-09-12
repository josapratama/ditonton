import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tTVSeriesTable = TVSeriesTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  const tJson = {
    'id': 1,
    'name': 'name',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  final tTVSeriesWatchlist = TVSeries.watchlist(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('TVSeriesTable', () {
    test('fromEntity should create TVSeriesTable from TVSeriesDetail', () {
      final result = TVSeriesTable.fromEntity(testTVSeriesDetail);
      expect(result.id, testTVSeriesDetail.id);
      expect(result.name, testTVSeriesDetail.name);
      expect(result.posterPath, testTVSeriesDetail.posterPath);
      expect(result.overview, testTVSeriesDetail.overview);
    });

    test('fromMap should create TVSeriesTable from map', () {
      final result = TVSeriesTable.fromMap(tJson);
      expect(result, tTVSeriesTable);
    });

    test('toJson should return correct map', () {
      final result = tTVSeriesTable.toJson();
      expect(result, tJson);
    });

    test('toEntity should return a TVSeries watchlist entity', () {
      final result = tTVSeriesTable.toEntity();
      expect(result, tTVSeriesWatchlist);
    });

    test('props should contain all fields', () {
      expect(tTVSeriesTable.props, [1, 'name', 'posterPath', 'overview']);
    });
  });
}
