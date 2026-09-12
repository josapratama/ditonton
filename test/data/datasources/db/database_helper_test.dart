import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  });

  setUp(() async {
    DatabaseHelper.resetInstance();
    databaseHelper = DatabaseHelper();
    // Force initialization with a fresh in-memory database
    await databaseHelper.initForTest();
  });

  tearDown(() async {
    final db = await databaseHelper.database;
    await db?.close();
    DatabaseHelper.resetInstance();
  });

  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTVSeriesTable = TVSeriesTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('Movie Watchlist', () {
    test('insertWatchlist should return id on success', () async {
      final result = await databaseHelper.insertWatchlist(tMovieTable);
      expect(result, 1);
    });

    test('getMovieById should return movie when found', () async {
      await databaseHelper.insertWatchlist(tMovieTable);
      final result = await databaseHelper.getMovieById(1);
      expect(result, isNotNull);
      expect(result!['id'], 1);
    });

    test('getMovieById should return null when not found', () async {
      final result = await databaseHelper.getMovieById(999);
      expect(result, isNull);
    });

    test('getWatchlistMovies should return list of movies', () async {
      await databaseHelper.insertWatchlist(tMovieTable);
      final result = await databaseHelper.getWatchlistMovies();
      expect(result, isNotEmpty);
      expect(result.first['id'], 1);
    });

    test('removeWatchlist should delete movie', () async {
      await databaseHelper.insertWatchlist(tMovieTable);
      await databaseHelper.removeWatchlist(tMovieTable);
      final result = await databaseHelper.getMovieById(1);
      expect(result, isNull);
    });
  });

  group('TV Series Watchlist', () {
    test('insertWatchlistTVSeries should return id on success', () async {
      final result = await databaseHelper.insertWatchlistTVSeries(
        tTVSeriesTable,
      );
      expect(result, 1);
    });

    test('getTVSeriesById should return tv series when found', () async {
      await databaseHelper.insertWatchlistTVSeries(tTVSeriesTable);
      final result = await databaseHelper.getTVSeriesById(1);
      expect(result, isNotNull);
      expect(result!['id'], 1);
    });

    test('getTVSeriesById should return null when not found', () async {
      final result = await databaseHelper.getTVSeriesById(999);
      expect(result, isNull);
    });

    test('getWatchlistTVSeries should return list of tv series', () async {
      await databaseHelper.insertWatchlistTVSeries(tTVSeriesTable);
      final result = await databaseHelper.getWatchlistTVSeries();
      expect(result, isNotEmpty);
      expect(result.first['id'], 1);
    });

    test('removeWatchlistTVSeries should delete tv series', () async {
      await databaseHelper.insertWatchlistTVSeries(tTVSeriesTable);
      await databaseHelper.removeWatchlistTVSeries(tTVSeriesTable);
      final result = await databaseHelper.getTVSeriesById(1);
      expect(result, isNull);
    });
  });
}
