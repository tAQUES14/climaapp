import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clima_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ClimaNovaApp());

    // Exemplo fictício de teste - provavelmente você vai precisar ajustar os testes abaixo,
    // já que o app não tem contador '+' como no projeto padrão do Flutter.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
