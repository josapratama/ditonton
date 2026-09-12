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

void main() {
  late MockMovieDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
  });

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeWidget() => BlocProvider<MovieDetailBloc>.value(
    value: mockBloc,
    child: MaterialApp(home: MovieDetailPage(id: 1)),
  );

  MovieDetailState buildState({
    RequestState movieState = RequestState.empty,
    RequestState recommendationState = RequestState.empty,
    bool isAddedToWatchlist = false,
    String message = '',
    String watchlistMessage = '',
  }) => MovieDetailState.initial().copyWith(
    movieState: movieState,
    movie: movieState == RequestState.loaded ? testMovieDetail : null,
    recommendations: const <Movie>[],
    recommendationState: recommendationState,
    isAddedToWatchlist: isAddedToWatchlist,
    message: message,
    watchlistMessage: watchlistMessage,
  );

  testWidgets('Page should display progress bar when loading', (tester) async {
    when(() => mockBloc.state)
        .thenReturn(buildState(movieState: RequestState.loading));

    await tester.pumpWidget(makeWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error message when error', (tester) async {
    when(() => mockBloc.state).thenReturn(
      buildState(movieState: RequestState.error, message: 'Error occurred'),
    );

    await tester.pumpWidget(makeWidget());

    expect(find.text('Error occurred'), findsOneWidget);
  });

  testWidgets(
    'DetailContent should show loading when recommendations loading',
    (tester) async {
      when(() => mockBloc.state).thenReturn(
        buildState(
          movieState: RequestState.loaded,
          recommendationState: RequestState.loading,
        ),
      );

      await tester.pumpWidget(makeWidget());

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    },
  );

  testWidgets('DetailContent should show error when recommendations error', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      buildState(
        movieState: RequestState.loaded,
        recommendationState: RequestState.error,
        message: 'Recommendations error',
      ),
    );

    await tester.pumpWidget(makeWidget());

    expect(find.text('Recommendations error'), findsOneWidget);
  });

  testWidgets('Watchlist button remove should show snackbar', (tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([
        buildState(
          movieState: RequestState.loaded,
          recommendationState: RequestState.loaded,
          isAddedToWatchlist: false,
          watchlistMessage: 'Removed from Watchlist',
        ),
      ]),
      initialState: buildState(
        movieState: RequestState.loaded,
        recommendationState: RequestState.loaded,
        isAddedToWatchlist: true,
      ),
    );

    await tester.pumpWidget(makeWidget());
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });
}
