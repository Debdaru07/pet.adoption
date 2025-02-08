import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption/screens/adoption_timelines.dart';

void main() {
  testWidgets('Displays adoption timeline', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdoptedPetsTimelineScreen()));

    expect(find.text('Adoption Timeline'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
