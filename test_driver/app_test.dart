import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

/// Integration tests for the project
///
/// They test the initial connection status
/// as well as if every page is reachable from
/// the main page.

// Start the integration tests
// (from the terminal only)
void main() {
  group('RehApp integration tests', () {
    final drawerFinder = find.byValueKey("menu_icon");
    final settingsFinder = find.byValueKey("settings_drawer");
    final statusFinder = find.byValueKey("status_text");
    final pageTitleFinder = find.byValueKey("page_title");
    final aboutFinder = find.byValueKey("about_drawer");
    final recoveryFinder = find.text("recovery_option");
    final gameFinder = find.byValueKey("game_option");
    final exerciseFinder = find.byValueKey("exercise_option");
    final backArrowFinder = find.byValueKey("back_arrow");
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDown(() async {
      await driver.waitFor(backArrowFinder);
      await driver.tap(backArrowFinder);
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    // Go to Settings and check the title
    test('Settings title', () async {
      await driver.waitFor(drawerFinder);
      await driver.tap(drawerFinder);
      await driver.waitFor(settingsFinder);
      await driver.tap(settingsFinder);
      expect(await driver.getText(pageTitleFinder), "Settings");
    });

    // Go to Settings and check the status
    test('Settings status', () async {
      await driver.waitFor(drawerFinder);
      await driver.tap(drawerFinder);
      await driver.waitFor(settingsFinder);
      await driver.tap(settingsFinder);
      expect(await driver.getText(statusFinder),
          "Status:  Turn your bluetooth on");
    });

    // Test if we can get to the About page
    test('About availability', () async {
      await driver.waitFor(drawerFinder);
      await driver.tap(drawerFinder);
      await driver.waitFor(aboutFinder);
      await driver.tap(aboutFinder);
      expect(await driver.getText(pageTitleFinder), "About");
    });

    // Test if we can get to the Recovery page
    test('Recovery availability', () async {
      await driver.waitFor(recoveryFinder);
      await driver.tap(recoveryFinder);
      expect(await driver.getText(pageTitleFinder), "Recovery");
    });

    // Test if we can get to the Exercise page
    test('Exercise availability', () async {
      await driver.waitFor(exerciseFinder);
      await driver.tap(exerciseFinder);
      expect(await driver.getText(pageTitleFinder), "Exercise");
    });

    // Test if we can get to the Game page
    test('Game availability', () async {
      await driver.waitFor(gameFinder);
      await driver.tap(gameFinder);
      expect(await driver.getText(pageTitleFinder), "Game");
    });
  });
}
