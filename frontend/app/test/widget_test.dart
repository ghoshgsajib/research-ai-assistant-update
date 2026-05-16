import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ResearchAIAssistantApp());

    expect(find.text('Research AI Assistant'), findsWidgets);
  });
}
