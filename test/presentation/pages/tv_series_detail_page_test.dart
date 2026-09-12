import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTVSeriesDetailBloc
    extends MockBloc<TVSeriesDetailEvent, TVSeriesDetailState>
    implements TVSeriesDetailBloc {}

class FakeTVSeriesDetailEvent extends Fake implements TVSeriesDetailEvent {}

class FakeTVSeriesDetailState extends Fake implements TVSeriesDetailState {}

void main() {
  late MockTVSeriesDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTVSeriesDetailEvent());
    registerFallbackValue(FakeTVSeriesDetailState());
  });

  setUp(() {
    mockBloc = MockTVSeriesDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TVSeriesDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  TVSeriesDetailState loadedState({
    bool isAddedToWatchlist = false,
    String watchlistMessage = '',
  }) => TVSeriesDetailState.initial().copyWith(
    tvSeriesState: RequestState.loaded,
    tvSeries: testTVSeriesDetail,
    recommendations: const <TVSeries>[],
    recommendationState: RequestState.loaded,
    isAddedToWatchlist: isAddedToWatchlist,
    watchlistMessage: watchlistMessage,
  );

  testWidgets('Page should display progress bar when loading', (tester) async {
    when(() => mockBloc.state).thenReturn(
      TVSeriesDetailState.initial().copyWith(
        tvSeriesState: RequestState.loading,
      ),
    );

    await tester.pumpWidget(
      makeTestableWidget(const TVSeriesDetailPage(id: 1)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display add icon when TV series not in watchlist',
    (tester) async {
      when(() => mockBloc.state).thenReturn(loadedState());

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 1)),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when TV series is in watchlist',
    (tester) async {
      when(() => mockBloc.state)
          .thenReturn(loadedState(isAddedToWatchlist: true));

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 1)),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          loadedState(
            watchlistMessage: TVSeriesDetailBloc.watchlistAddSuccessMessage,
          ),
          loadedState(
            watchlistMessage: TVSeriesDetailBloc.watchlistAddSuccessMessage,
            isAddedToWatchlist: true,
          ),
        ]),
        initialState: loadedState(),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 1)),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(TVSeriesDetailBloc.watchlistAddSuccessMessage),
        findsOneWidget,
      );
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

      await tester.pumpWidget(
        makeTestableWidget(const TVSeriesDetailPage(id: 1)),
      );
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );

  testWidgets('Page should display error text when loading fails', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TVSeriesDetailState.initial().copyWith(
        tvSeriesState: RequestState.error,
        message: 'Failed to load TV series',
      ),
    );

    await tester.pumpWidget(
      makeTestableWidget(const TVSeriesDetailPage(id: 1)),
    );

    expect(find.text('Failed to load TV series'), findsOneWidget);
  });
}
