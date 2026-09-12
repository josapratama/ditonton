import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
  });

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  MovieDetailState loadedState({
    bool isAddedToWatchlist = false,
    String watchlistMessage = '',
  }) => MovieDetailState.initial().copyWith(
    movieState: RequestState.loaded,
    movie: testMovieDetail,
    recommendations: const <Movie>[],
    recommendationState: RequestState.loaded,
    isAddedToWatchlist: isAddedToWatchlist,
    watchlistMessage: watchlistMessage,
  );

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (tester) async {
      when(() => mockBloc.state).thenReturn(loadedState());

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (tester) async {
      when(() => mockBloc.state)
          .thenReturn(loadedState(isAddedToWatchlist: true));

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (tester) async {
      // Set up stream before pumpWidget so listener fires on first emission
      whenListen(
        mockBloc,
        Stream.fromIterable([
          loadedState(watchlistMessage: 'Added to Watchlist'),
          loadedState(
            watchlistMessage: 'Added to Watchlist',
            isAddedToWatchlist: true,
          ),
        ]),
        initialState: loadedState(),
      );

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump(); // process stream emissions

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([loadedState(watchlistMessage: 'Failed')]),
        initialState: loadedState(),
      );

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}
