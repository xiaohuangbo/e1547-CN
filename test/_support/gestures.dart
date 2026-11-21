import 'package:flutter_test/flutter_test.dart';

Future<TestGesture> dragSlowly(
  WidgetTester tester,
  Offset from,
  Offset step, {
  int steps = 20,
  Duration pace = const Duration(milliseconds: 100),
}) async {
  final TestGesture finger = await tester.startGesture(from);
  Duration at = Duration.zero;
  for (int i = 0; i < steps; i++) {
    at += pace;
    await finger.moveBy(step, timeStamp: at);
    await tester.pump(pace);
  }
  return finger;
}

Future<void> doubleTap(WidgetTester tester, Offset at) async {
  await tester.tapAt(at);
  await tester.pump(const Duration(milliseconds: 50));
  await tester.tapAt(at);
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

void reserveBottomGestureArea(WidgetTester tester) {
  tester.view.systemGestureInsets = FakeViewPadding(
    bottom: 48 * tester.view.devicePixelRatio,
  );
  addTearDown(tester.view.resetSystemGestureInsets);
}
