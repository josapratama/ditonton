import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/tv_series_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

class MockTVSeriesSearchBloc
    extends MockBloc<TVSeriesSearchEvent, TVSeriesSearchState>
    implements TVSeriesSearchBloc {}

void main() {
  late MockMovieSearchBloc mockMovieSearchBloc;
  late MockTVSeriesSearchBloc mockTVSearchBloc;

  setUp(() {
    mockMovieSearchBloc = MockMovieSearchBloc();
    mockTVSearchBloc = MockTVSeriesSearchBloc();
  });

  group('SearchPage with results', () {
    testWidgets('should display movie cards when search has results', (
      tester,
    ) async {
      when(() => mockMovieSearchBloc.state)
          .thenReturn(MovieSearchLoaded([testMovie]));

      await tester.pumpWidget(
        BlocProvider<MovieSearchBloc>.value(
          value: mockMovieSearchBloc,
          child: MaterialApp(
            home: SearchPage(),
            onGenerateRoute: (_) =>
                MaterialPageRoute(builder: (_) => const Scaffold()),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });

  group('TVSeriesSearchPage with results', () {
    testWidgets('should display tv series cards when search has results', (
      tester,
    ) async {
      when(() => mockTVSearchBloc.state)
          .thenReturn(TVSeriesSearchLoaded([testTVSeries]));

      await tester.pumpWidget(
        BlocProvider<TVSeriesSearchBloc>.value(
          value: mockTVSearchBloc,
          child: MaterialApp(
            home: const TVSeriesSearchPage(),
            onGenerateRoute: (_) =>
                MaterialPageRoute(builder: (_) => const Scaffold()),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
