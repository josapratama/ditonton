import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularMoviesBloc extends MockBloc<MovieListEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

class MockTopRatedMoviesBloc
    extends MockBloc<MovieListEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

class MockPopularTVSeriesBloc
    extends MockBloc<TVSeriesListEvent, PopularTVSeriesState>
    implements PopularTVSeriesBloc {}

class MockTopRatedTVSeriesBloc
    extends MockBloc<TVSeriesListEvent, TopRatedTVSeriesState>
    implements TopRatedTVSeriesBloc {}

void main() {
  late MockPopularMoviesBloc mockPopularMovies;
  late MockTopRatedMoviesBloc mockTopRated;
  late MockPopularTVSeriesBloc mockPopularTV;
  late MockTopRatedTVSeriesBloc mockTopRatedTV;

  setUp(() {
    mockPopularMovies = MockPopularMoviesBloc();
    mockTopRated = MockTopRatedMoviesBloc();
    mockPopularTV = MockPopularTVSeriesBloc();
    mockTopRatedTV = MockTopRatedTVSeriesBloc();
  });

  group('PopularMoviesPage', () {
    testWidgets('should display movie cards when loaded with items', (
      tester,
    ) async {
      when(() => mockPopularMovies.state)
          .thenReturn(PopularMoviesLoaded([testMovie]));

      await tester.pumpWidget(
        BlocProvider<PopularMoviesBloc>.value(
          value: mockPopularMovies,
          child: MaterialApp(
            home: PopularMoviesPage(),
            onGenerateRoute: (_) =>
                MaterialPageRoute(builder: (_) => const Scaffold()),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('TopRatedMoviesPage', () {
    testWidgets('should display movie cards when loaded with items', (
      tester,
    ) async {
      when(() => mockTopRated.state)
          .thenReturn(TopRatedMoviesLoaded([testMovie]));

      await tester.pumpWidget(
        BlocProvider<TopRatedMoviesBloc>.value(
          value: mockTopRated,
          child: MaterialApp(
            home: TopRatedMoviesPage(),
            onGenerateRoute: (_) =>
                MaterialPageRoute(builder: (_) => const Scaffold()),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('PopularTVSeriesPage', () {
    testWidgets('should display tv series cards when loaded with items', (
      tester,
    ) async {
      when(() => mockPopularTV.state)
          .thenReturn(PopularTVSeriesLoaded([testTVSeries]));

      await tester.pumpWidget(
        BlocProvider<PopularTVSeriesBloc>.value(
          value: mockPopularTV,
          child: MaterialApp(
            home: const PopularTVSeriesPage(),
            onGenerateRoute: (_) =>
                MaterialPageRoute(builder: (_) => const Scaffold()),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('TopRatedTVSeriesPage', () {
    testWidgets('should display tv series cards when loaded with items', (
      tester,
    ) async {
      when(() => mockTopRatedTV.state)
          .thenReturn(TopRatedTVSeriesLoaded([testTVSeries]));

      await tester.pumpWidget(
        BlocProvider<TopRatedTVSeriesBloc>.value(
          value: mockTopRatedTV,
          child: MaterialApp(
            home: const TopRatedTVSeriesPage(),
            onGenerateRoute: (_) =>
                MaterialPageRoute(builder: (_) => const Scaffold()),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
