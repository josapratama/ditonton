import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTopRatedMoviesBloc
    extends MockBloc<MovieListEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedMoviesLoading());

    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (tester) async {
    when(() => mockBloc.state)
        .thenReturn(TopRatedMoviesLoaded(const <Movie>[]));

    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    tester,
  ) async {
    when(() => mockBloc.state)
        .thenReturn(const TopRatedMoviesError('Error message'));

    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
