import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption/screens/pet_details.dart';
void main() {
  testWidgets('Displays pet details and navigates to adoption timeline', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PetDetailPage(petId: 1, index: 1,)));
    expect(find.textContaining('Adopt'), findsOneWidget);
    await tester.tap(find.textContaining('Adopt'));
    await tester.pumpAndSettle();

  });
}