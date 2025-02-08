import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pet_adoption/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-end test for pet adoption flow', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('PetAdopt'), findsOneWidget);
    expect(find.textContaining('Show Timeline'), findsOneWidget);
    await tester.tap(find.text('Buddy'));
    await tester.pumpAndSettle();
    expect(find.text('Pet Details'), findsOneWidget);
    await tester.tap(find.textContaining('Adopt'));
    await tester.pumpAndSettle();
  });
}
