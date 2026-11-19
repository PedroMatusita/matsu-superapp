import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:super_app/main.dart';

void main() {
  testWidgets('shows the notes app and opens the editor', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const NoteApp());
    await tester.pumpAndSettle();

    expect(find.text('Notas'), findsOneWidget);
    expect(find.text('Nenhuma nota encontrada.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Título'), findsOneWidget);
    expect(find.text('Pronto'), findsOneWidget);
  });

  testWidgets('adds and toggles a checklist item inside a note', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const NoteApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Adicionar checklist'));
    await tester.pumpAndSettle();

    expect(find.byType(Checkbox), findsOneWidget);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.value, isTrue);
  });
}
