import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchlistTVSeriesBloc
    extends MockBloc<WatchlistTVSeriesEvent, WatchlistTVSeriesState>
    implements WatchlistTVSeriesBloc {}

void main() {
  late MockWatchlistTVSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockWatchlistTVSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTVSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(WatchlistTVSeriesLoading());

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(WatchlistTVSeriesLoaded(const <TVSeries>[]));

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error', (tester) async {
    when(() => mockBloc.state)
        .thenReturn(const WatchlistTVSeriesError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
