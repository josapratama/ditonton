import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (settings) {
        if (settings.name == TVSeriesDetailPage.routeName) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('TV Detail Page')),
          );
        }
        return null;
      },
    );
  }

  testWidgets('TVSeriesCard should display tv series name and overview',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

    expect(find.text(testTVSeries.name!), findsOneWidget);
    expect(find.text(testTVSeries.overview!), findsOneWidget);
  });

  testWidgets('TVSeriesCard should navigate to detail page on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(TVSeriesCard(testTVSeries)));

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('TV Detail Page'), findsOneWidget);
  });

  testWidgets('TVSeriesCard should render without crash for watchlist entry',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(makeTestableWidget(TVSeriesCard(testWatchlistTVSeries)));
    expect(find.byType(TVSeriesCard), findsOneWidget);
  });
}
