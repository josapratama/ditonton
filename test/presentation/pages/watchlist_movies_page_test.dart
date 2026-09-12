import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

void main() {
  late MockWatchlistMovieBloc mockBloc;

  setUp(() {
    mockBloc = MockWatchlistMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(WatchlistMovieLoading());

    await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(WatchlistMovieLoaded(const <Movie>[]));

    await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error', (tester) async {
    when(() => mockBloc.state)
        .thenReturn(const WatchlistMovieError('Error message'));

    await tester.pumpWidget(makeTestableWidget(WatchlistMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
