import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/pages/home_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnAirTVSeriesBloc
    extends MockBloc<TVSeriesListEvent, OnAirTVSeriesState>
    implements OnAirTVSeriesBloc {}

class MockPopularTVSeriesBloc
    extends MockBloc<TVSeriesListEvent, PopularTVSeriesState>
    implements PopularTVSeriesBloc {}

class MockTopRatedTVSeriesBloc
    extends MockBloc<TVSeriesListEvent, TopRatedTVSeriesState>
    implements TopRatedTVSeriesBloc {}

void main() {
  late MockOnAirTVSeriesBloc mockOnAirBloc;
  late MockPopularTVSeriesBloc mockPopularBloc;
  late MockTopRatedTVSeriesBloc mockTopRatedBloc;

  setUp(() {
    mockOnAirBloc = MockOnAirTVSeriesBloc();
    mockPopularBloc = MockPopularTVSeriesBloc();
    mockTopRatedBloc = MockTopRatedTVSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnAirTVSeriesBloc>.value(value: mockOnAirBloc),
        BlocProvider<PopularTVSeriesBloc>.value(value: mockPopularBloc),
        BlocProvider<TopRatedTVSeriesBloc>.value(value: mockTopRatedBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  void arrangeAllLoaded() {
    when(() => mockOnAirBloc.state)
        .thenReturn(OnAirTVSeriesLoaded(const <TVSeries>[]));
    when(() => mockPopularBloc.state)
        .thenReturn(PopularTVSeriesLoaded(const <TVSeries>[]));
    when(() => mockTopRatedBloc.state)
        .thenReturn(TopRatedTVSeriesLoaded(const <TVSeries>[]));
  }

  testWidgets('Page should display progress bars when all sections loading', (
    tester,
  ) async {
    when(() => mockOnAirBloc.state).thenReturn(OnAirTVSeriesLoading());
    when(() => mockPopularBloc.state).thenReturn(PopularTVSeriesLoading());
    when(() => mockTopRatedBloc.state).thenReturn(TopRatedTVSeriesLoading());

    await tester.pumpWidget(makeTestableWidget(const HomeTVSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('Page should display On Air section label when loaded', (
    tester,
  ) async {
    arrangeAllLoaded();

    await tester.pumpWidget(makeTestableWidget(const HomeTVSeriesPage()));

    expect(find.text('On Air'), findsOneWidget);
  });

  testWidgets('Page should display Popular section label when loaded', (
    tester,
  ) async {
    arrangeAllLoaded();

    await tester.pumpWidget(makeTestableWidget(const HomeTVSeriesPage()));

    expect(find.text('Popular'), findsOneWidget);
  });

  testWidgets('Page should display Top Rated section label when loaded', (
    tester,
  ) async {
    arrangeAllLoaded();

    await tester.pumpWidget(makeTestableWidget(const HomeTVSeriesPage()));

    expect(find.text('Top Rated'), findsOneWidget);
  });

  testWidgets('Page should display Failed text when on air section errors', (
    tester,
  ) async {
    when(() => mockOnAirBloc.state)
        .thenReturn(const OnAirTVSeriesError('Server Error'));
    when(() => mockPopularBloc.state)
        .thenReturn(PopularTVSeriesLoaded(const <TVSeries>[]));
    when(() => mockTopRatedBloc.state)
        .thenReturn(TopRatedTVSeriesLoaded(const <TVSeries>[]));

    await tester.pumpWidget(makeTestableWidget(const HomeTVSeriesPage()));

    expect(find.text('Server Error'), findsOneWidget);
  });

  testWidgets(
    'Page should display Failed texts when popular and top rated error',
    (tester) async {
      when(() => mockOnAirBloc.state)
          .thenReturn(OnAirTVSeriesLoaded(const <TVSeries>[]));
      when(() => mockPopularBloc.state)
          .thenReturn(const PopularTVSeriesError('Failed'));
      when(() => mockTopRatedBloc.state)
          .thenReturn(const TopRatedTVSeriesError('Failed'));

      await tester.pumpWidget(makeTestableWidget(const HomeTVSeriesPage()));

      expect(find.text('Failed'), findsWidgets);
    },
  );

  testWidgets('Page should have drawer with navigation items', (tester) async {
    arrangeAllLoaded();

    await tester.pumpWidget(makeTestableWidget(const HomeTVSeriesPage()));

    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
  });
}
