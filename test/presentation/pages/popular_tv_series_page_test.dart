import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPopularTVSeriesBloc
    extends MockBloc<TVSeriesListEvent, PopularTVSeriesState>
    implements PopularTVSeriesBloc {}

void main() {
  late MockPopularTVSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularTVSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTVSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(PopularTVSeriesLoading());

    await tester.pumpWidget(makeTestableWidget(const PopularTVSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(PopularTVSeriesLoaded(const <TVSeries>[]));

    await tester.pumpWidget(makeTestableWidget(const PopularTVSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(const PopularTVSeriesError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const PopularTVSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
