import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTopRatedTVSeriesBloc
    extends MockBloc<TVSeriesListEvent, TopRatedTVSeriesState>
    implements TopRatedTVSeriesBloc {}

void main() {
  late MockTopRatedTVSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTVSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTVSeriesLoading());

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(TopRatedTVSeriesLoaded(const <TVSeries>[]));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(const TopRatedTVSeriesError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
