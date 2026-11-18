import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('TaskFlowApp renders LoginScreen when no session exists', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const TaskFlowApp());
    await tester.pumpAndSettle();

    expect(find.text('TaskFlow'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
