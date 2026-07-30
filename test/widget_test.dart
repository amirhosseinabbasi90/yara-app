import 'package:flutter_test/flutter_test.dart';
import 'package:yara_app/main.dart';

void main() {
  testWidgets('app starts and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const YaraApp());

    expect(find.text('یارا'), findsOneWidget);
    expect(find.text('دستیار مدیریت گوشی و زندگی دیجیتال'), findsOneWidget);
  });
}
