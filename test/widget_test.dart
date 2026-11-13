import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_profil_mahasiswa/main.dart';

void main() {
  testWidgets('NoteFormScreen validation smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Tambah Catatan Kuliah'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Judul tidak boleh kosong'), findsOneWidget);
    expect(find.text('Isi catatan tidak boleh kosong'), findsOneWidget);
  });
}
