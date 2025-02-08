import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption/screens/listing.dart';

void main() {
  testWidgets('Displays pet list and navigates to details', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PetListScreen()));
    expect(find.text('PetAdopt'), findsOneWidget);
    expect(find.text('Show Timeline'), findsOneWidget);
    final petTile = find.text('Max');
    expect(petTile, findsOneWidget);
    await tester.tap(petTile);
    await tester.pumpAndSettle();
    expect(find.text('Pet Details'), findsOneWidget);
  });
}
