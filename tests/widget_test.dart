import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wobble_board/bloc/app.dart';
import 'package:wobble_board/bloc/bloc_provider.dart';
import 'package:wobble_board/main.dart';
import 'package:wobble_board/resources/repository.dart';
import 'package:wobble_board/ui/pages/exercise_page.dart';
import 'package:wobble_board/ui/pages/settings_page.dart';
import 'package:wobble_board/ui/widgets/custom_dialog.dart';

/// Widget tests for the project

// Run widget tests
void main() {

  // Test the submit dialog and the validation check
  _testSubmitDialog();

  // Test the Settings page
  _testSettingsPage();

  // Test the Exercise page
  _testExercisePage();
}

_testSubmitDialog() {
  testWidgets('Test submit dialog', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CustomDialog(
          4.2,
              () {}
      ),
      theme: themeData,
    ));

    expect(find.text("Total time: 4.2s"), findsOneWidget);
    expect(find.widgetWithText(RaisedButton, "Cancel"), findsOneWidget);
    expect(find.widgetWithText(RaisedButton, "Submit"), findsOneWidget);
    expect(find.text("required field"), findsNothing);


    await tester.tap(find.widgetWithText(RaisedButton, "Submit"));
    await tester.pumpAndSettle();

    expect(find.text("required field"), findsOneWidget);
  });
}

_testSettingsPage() {
  testWidgets('Test Settings page', (WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider(
      bloc: AppBloc(),
      child: MaterialApp(
        home: Settings(),
        theme: themeData,
      ),
    ));

    expect(find.text("Settings"), findsOneWidget);
    expect(find.widgetWithText(InkWell, "Connect"), findsOneWidget);
    expect(find.widgetWithText(InkWell, "Disconnect"), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}

_testExercisePage() {
  testWidgets('Test Exercise page', (WidgetTester tester) async {
    final repo = Repository();
    await tester.pumpWidget(BlocProvider(
      bloc: AppBloc(),
      child: MaterialApp(
        home: ExercisePage(),
        theme: themeData,
      ),
    ));

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text("Exercise"), findsOneWidget);
    expect(find.widgetWithText(RaisedButton, "GO"), findsOneWidget);
    expect(find.byType(ListTile, skipOffstage: false), findsNWidgets(repo.getExercises().length));
    repo.getExercises().forEach((e) {
          expect(find.widgetWithText(ListTile, e.title, skipOffstage: false), findsOneWidget);
        });
  });
}