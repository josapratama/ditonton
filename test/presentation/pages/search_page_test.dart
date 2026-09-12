import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

void main() {
  late MockMovieSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieSearchBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (tester) async {
    when(() => mockBloc.state).thenReturn(MovieSearchLoading());

    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(MovieSearchLoaded(const <Movie>[]));

    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display search UI when state is Empty', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(MovieSearchEmpty());

    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search Result'), findsOneWidget);
  });

  testWidgets('TextField should trigger search on submit', (tester) async {
    when(() => mockBloc.state).thenReturn(MovieSearchEmpty());

    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'spider man');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(() => mockBloc.add(const OnMovieQueryChanged('spider man')))
        .called(1);
  });
}
