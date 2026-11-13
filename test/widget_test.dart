import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_profil_mahasiswa/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    expect(find.text('Data Publik (HTTP GET)'), findsOneWidget);
  });
}
