import 'package:collection_box/collection_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CollectionBox Widget Tests', () {
    testWidgets('CollectionBox renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CollectionBox(
            onCollectionChanged: (_) {},
          ),
        ),
      ));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.text('Please add at least one item to the section'),
          findsOneWidget);
    });

    testWidgets('Can add items to collection', (WidgetTester tester) async {
      List<String> currentCollection = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CollectionBox(
            onCollectionChanged: (collection) {
              currentCollection = collection;
            },
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), 'Test Skill');
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(find.text('Test Skill'), findsOneWidget);
      expect(currentCollection, contains('Test Skill'));
    });

    testWidgets('Can remove items from collection',
        (WidgetTester tester) async {
      List<String> currentCollection = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CollectionBox(
            collection: const ['Initial Skill'],
            onCollectionChanged: (collection) {
              currentCollection = collection;
            },
          ),
        ),
      ));

      expect(find.text('Initial Skill'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(find.text('Initial Skill'), findsNothing);
      expect(currentCollection, isEmpty);
    });

    testWidgets('Respects item limit', (WidgetTester tester) async {
      List<String> currentCollection = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CollectionBox(
            limit: 2,
            onCollectionChanged: (collection) {
              currentCollection = collection;
            },
          ),
        ),
      ));

      for (int i = 1; i <= 3; i++) {
        await tester.enterText(find.byType(TextField), 'Skill $i');
        await tester.tap(find.byType(IconButton));
        await tester.pump();
      }

      expect(find.text('Skill 1'), findsOneWidget);
      expect(find.text('Skill 2'), findsOneWidget);
      expect(find.text('Skill 3'), findsNothing);
      expect(currentCollection.length, 2);
    });

    testWidgets('Does not add duplicate items', (WidgetTester tester) async {
      List<String> currentCollection = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CollectionBox(
            onCollectionChanged: (collection) {
              currentCollection = collection;
            },
          ),
        ),
      ));

      await tester.enterText(find.byType(TextField), 'Duplicate Skill');
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Duplicate Skill');
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(find.text('Duplicate Skill'), findsOneWidget);
      expect(currentCollection.length, 1);
    });

    testWidgets('Applies custom input decoration', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CollectionBox(
            onCollectionChanged: (_) {},
            inputDecoration: const InputDecoration(
              hintText: 'Custom Hint',
              border: InputBorder.none,
            ),
          ),
        ),
      ));

      expect(find.text('Custom Hint'), findsOneWidget);
      expect(find.byType(OutlineInputBorder), findsNothing);
    });

    testWidgets('Applies custom border color', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CollectionBox(
            onCollectionChanged: (_) {},
            borderColor: Colors.red,
          ),
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border!.top.color, Colors.red);
    });
  });
}
