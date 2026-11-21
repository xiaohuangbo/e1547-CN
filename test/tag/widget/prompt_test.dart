import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  Future<void> open(WidgetTester tester, {TargetPlatform? platform}) async {
    await tester.runAsync(
      () => tester.pumpWidget(
        env.app(
          theme: platform == null ? null : ThemeData(platform: platform),
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () =>
                    showTagSearchPrompt(context: context, tag: 'fox'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await env.settle(tester, animating: true);
  }

  double top(WidgetTester tester, Finder finder) =>
      tester.getTopLeft(finder.first).dy;

  displayTest('a tag sheet puts a divider and then its actions under the '
      'name, however short the name', (tester) async {
    await open(tester);

    final double name = tester.getBottomLeft(find.text('fox')).dy;
    final double divider = top(tester, find.byType(Divider));
    expect(divider, greaterThanOrEqualTo(name));
    expect(top(tester, find.text('关注')), greaterThan(divider));
  });

  displayTest('a tag dialog on desktop has its actions beside the name', (
    tester,
  ) async {
    await open(tester, platform: TargetPlatform.linux);

    final Rect name = tester.getRect(find.text('fox'));
    final Rect action = tester.getRect(find.text('关注'));
    expect(action.left, greaterThan(name.right));
    expect(action.top, lessThan(name.bottom));
  });

  displayTest('a tag dialog on a narrow desktop window keeps its actions '
      'clear of the name', (tester) async {
    tester.view.physicalSize = Size(
      360 * tester.view.devicePixelRatio,
      800 * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetPhysicalSize);
    await open(tester, platform: TargetPlatform.linux);

    final Rect name = tester.getRect(find.text('fox'));
    final Rect action = tester.getRect(find.text('关注'));
    // The translated action label is shorter than the english original, so on
    // a narrow window the actions may still fit beside the name. What matters
    // is that they never overlap it.
    expect(action.overlaps(name), isFalse);
  });
}
