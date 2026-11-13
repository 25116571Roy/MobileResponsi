import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_profil_mahasiswa/main.dart';
import 'package:responsi_profil_mahasiswa/widgets/empty_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('HomeScreen smoke test and EmptyState check', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Catatan Kuliah'), findsOneWidget);
    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
