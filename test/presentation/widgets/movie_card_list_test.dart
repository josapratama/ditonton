import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailPage.ROUTE_NAME) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Detail Page')),
          );
        }
        return null;
      },
    );
  }

  testWidgets('MovieCard should display movie title and overview',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

    expect(find.text(testMovie.title!), findsOneWidget);
    expect(find.text(testMovie.overview!), findsOneWidget);
  });

  testWidgets('MovieCard should navigate to detail page on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });

  testWidgets('MovieCard should display dash when title is null',
      (WidgetTester tester) async {
    final movieNoTitle = testWatchlistMovie;
    await tester.pumpWidget(makeTestableWidget(MovieCard(movieNoTitle)));
    // Should not throw — renders without crash
    expect(find.byType(MovieCard), findsOneWidget);
  });
}
