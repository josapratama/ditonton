import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

  group('WatchlistMoviesPage RouteAware', () {
    testWidgets('didChangeDependencies should subscribe routeObserver', (
      tester,
    ) async {
      when(() => mockMovieBloc.state)
          .thenReturn(WatchlistMovieLoaded(const <Movie>[]));

      await tester.pumpWidget(
        BlocProvider<WatchlistMovieBloc>.value(
          value: mockMovieBloc,
          child: MaterialApp(
            navigatorObservers: [routeObserver],
            home: WatchlistMoviesPage(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(WatchlistMoviesPage), findsOneWidget);
    });

    testWidgets('didPopNext should refresh watchlist when popped back', (
      tester,
    ) async {
      when(() => mockMovieBloc.state)
          .thenReturn(WatchlistMovieLoaded(const <Movie>[]));

      await tester.pumpWidget(
        BlocProvider<WatchlistMovieBloc>.value(
          value: mockMovieBloc,
          child: MaterialApp(
            navigatorObservers: [routeObserver],
            home: WatchlistMoviesPage(),
          ),
        ),
      );

      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.push(
        MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Second Page')),
        ),
      );
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();

      // BLoC.add is called on didPopNext
      verify(() => mockMovieBloc.add(FetchWatchlistMovies()))
          .called(greaterThan(0));
    });
  });

  group('WatchlistTVSeriesPage RouteAware', () {
    testWidgets('didChangeDependencies should subscribe routeObserver', (
      tester,
    ) async {
      when(() => mockTVBloc.state)
          .thenReturn(WatchlistTVSeriesLoaded(const <TVSeries>[]));

      await tester.pumpWidget(
        BlocProvider<WatchlistTVSeriesBloc>.value(
          value: mockTVBloc,
          child: MaterialApp(
            navigatorObservers: [routeObserver],
            home: const WatchlistTVSeriesPage(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(WatchlistTVSeriesPage), findsOneWidget);
    });

    testWidgets('didPopNext should refresh watchlist when popped back', (
      tester,
    ) async {
      when(() => mockTVBloc.state)
          .thenReturn(WatchlistTVSeriesLoaded(const <TVSeries>[]));

      await tester.pumpWidget(
        BlocProvider<WatchlistTVSeriesBloc>.value(
          value: mockTVBloc,
          child: MaterialApp(
            navigatorObservers: [routeObserver],
            home: const WatchlistTVSeriesPage(),
          ),
        ),
      );

      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.push(
        MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Second Page')),
        ),
      );
      await tester.pumpAndSettle();
      navigator.pop();
      await tester.pumpAndSettle();

      verify(() => mockTVBloc.add(FetchWatchlistTVSeries()))
          .called(greaterThan(0));
    });
  });
}
