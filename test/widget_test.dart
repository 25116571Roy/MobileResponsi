import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_profil_mahasiswa/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Profil Mahasiswa'), findsOneWidget);
  });
}
