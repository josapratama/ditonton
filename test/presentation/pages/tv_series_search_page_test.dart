import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVSeriesSearchBloc
    extends MockBloc<TVSeriesSearchEvent, TVSeriesSearchState>
    implements TVSeriesSearchBloc {}

void main() {
  late MockTVSeriesSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockTVSeriesSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TVSeriesSearchBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (tester) async {
    when(() => mockBloc.state).thenReturn(TVSeriesSearchLoading());

    await tester.pumpWidget(makeTestableWidget(const TVSeriesSearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(TVSeriesSearchLoaded(const <TVSeries>[]));

    await tester.pumpWidget(makeTestableWidget(const TVSeriesSearchPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display search UI when state is Empty', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(TVSeriesSearchEmpty());

    await tester.pumpWidget(makeTestableWidget(const TVSeriesSearchPage()));

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search Result'), findsOneWidget);
  });

  testWidgets('TextField should trigger search on submit', (tester) async {
    when(() => mockBloc.state).thenReturn(TVSeriesSearchEmpty());

    await tester.pumpWidget(makeTestableWidget(const TVSeriesSearchPage()));

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'breaking bad');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(() => mockBloc.add(const OnTVSeriesQueryChanged('breaking bad')))
        .called(1);
  });
}
