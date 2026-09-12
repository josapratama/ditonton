import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class MockWatchlistTVSeriesBloc
    extends MockBloc<WatchlistTVSeriesEvent, WatchlistTVSeriesState>
    implements WatchlistTVSeriesBloc {}

void main() {
  late MockWatchlistMovieBloc mockMovieBloc;
  late MockWatchlistTVSeriesBloc mockTVBloc;

  setUp(() {
    mockMovieBloc = MockWatchlistMovieBloc();
    mockTVBloc = MockWatchlistTVSeriesBloc();
  });

  group('WatchlistMoviesPage with items', () {
    testWidgets('should display movie cards when watchlist has items', (
      tester,
    ) async {
      when(() => mockMovieBloc.state)
          .thenReturn(WatchlistMovieLoaded([testWatchlistMovie]));

      await tester.pumpWidget(
        BlocProvider<WatchlistMovieBloc>.value(
          value: mockMovieBloc,
          child: MaterialApp(
            home: WatchlistMoviesPage(),
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Detail')),
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('WatchlistTVSeriesPage with items', () {
    testWidgets('should display tv series cards when watchlist has items', (
      tester,
    ) async {
      when(() => mockTVBloc.state)
          .thenReturn(WatchlistTVSeriesLoaded([testWatchlistTVSeries]));

      await tester.pumpWidget(
        BlocProvider<WatchlistTVSeriesBloc>.value(
          value: mockTVBloc,
          child: MaterialApp(
            home: const WatchlistTVSeriesPage(),
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('TV Detail')),
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
