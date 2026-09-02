import 'package:book_ease/features/discover/presentation/views/widgets/search_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchInputField Widget Tests', () {
    testWidgets('renders hintText, search icon and filter icon properly',
        (WidgetTester tester) async {
      String enteredText = '';
      bool filterTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchInputField(
              hintText: 'Search doctors, clinics...',
              onChanged: (val) => enteredText = val,
              onFilterTap: () => filterTapped = true,
            ),
          ),
        ),
      );

      // Verify hint text is rendered
      expect(find.text('Search doctors, clinics...'), findsOneWidget);

      // Verify search icon is rendered
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);

      // Verify tune/filter icon is rendered
      expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

      // Enter text and verify callback
      await tester.enterText(find.byType(TextField), 'Cardiology');
      expect(enteredText, 'Cardiology');

      // Tap filter icon and verify callback
      await tester.tap(find.byIcon(Icons.tune_rounded));
      expect(filterTapped, isTrue);
    });
  });
}
