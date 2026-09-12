import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget() {
    return MaterialApp(
      home: AboutPage(),
    );
  }

  testWidgets('AboutPage should display description text',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    expect(
      find.textContaining('Ditonton'),
      findsWidgets,
    );
  });

  testWidgets('AboutPage should display back button',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('AboutPage back button should pop navigation',
      (WidgetTester tester) async {
    bool popped = false;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AboutPage()),
            );
          },
          child: const Text('Open'),
        ),
      ),
    ));

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(AboutPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(AboutPage), findsNothing);
  });
}
