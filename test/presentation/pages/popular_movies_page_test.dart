import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPopularMoviesBloc extends MockBloc<MovieListEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

void main() {
  late MockPopularMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(PopularMoviesLoading());

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(PopularMoviesLoaded(const <Movie>[]));

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(const PopularMoviesError('Error message'));

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
