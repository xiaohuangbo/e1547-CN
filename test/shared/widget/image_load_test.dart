import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ImageLoadController load;

  Future<void> show(
    WidgetTester tester,
    Rect? Function(Size size) locate, {
    Listenable? moves,
  }) async {
    load = ImageLoadController();
    addTearDown(load.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 400,
            height: 400,
            child: ImageLoadOverlay(load: load, locate: locate, moves: moves),
          ),
        ),
      ),
    );
  }

  Rect bar(WidgetTester tester) => tester
      .getRect(find.byType(LinearProgressIndicator))
      .shift(-tester.getTopLeft(find.byType(ImageLoadOverlay)));

  testWidgets('a load that finishes quickly shows no bar', (tester) async {
    await show(tester, (size) => const Rect.fromLTWH(100, 50, 200, 300));
    await tester.pump(imageLoadPatience ~/ 2);
    expect(find.byType(LinearProgressIndicator), findsNothing);

    load.value = const ImageLoaded();
    await tester.pump(imageLoadPatience * 2);

    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('a load that takes long shows its progress', (tester) async {
    await show(tester, (size) => const Rect.fromLTWH(100, 50, 200, 300));
    load.value = const ImageLoading(0.5);
    await tester.pump(imageLoadPatience * 2);

    final LinearProgressIndicator indicator = tester.widget(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, 0.5);
  });

  testWidgets('the bar is gone once the image has loaded', (tester) async {
    await show(tester, (size) => const Rect.fromLTWH(100, 50, 200, 300));
    await tester.pump(imageLoadPatience * 2);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    load.value = const ImageLoaded();
    await tester.pump();

    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('the bar is at the top edge of the image', (tester) async {
    await show(tester, (size) => const Rect.fromLTWH(100, 50, 200, 300));
    await tester.pump(imageLoadPatience * 2);

    expect(bar(tester).left, 100);
    expect(bar(tester).width, 200);
    expect(bar(tester).top, 50);
  });

  testWidgets('an image larger than the screen keeps the bar on screen', (
    tester,
  ) async {
    await show(tester, (size) => const Rect.fromLTWH(-200, -300, 800, 1200));
    await tester.pump(imageLoadPatience * 2);

    expect(bar(tester).left, 0);
    expect(bar(tester).width, 400);
    expect(bar(tester).top, 0);
  });

  testWidgets('the bar follows the image when it moves', (tester) async {
    final ValueNotifier<Offset> moved = ValueNotifier<Offset>(Offset.zero);
    addTearDown(moved.dispose);
    await show(
      tester,
      (size) => const Rect.fromLTWH(100, 50, 200, 300).shift(moved.value),
      moves: moved,
    );
    await tester.pump(imageLoadPatience * 2);

    moved.value = const Offset(-40, 30);
    await tester.pump();

    expect(bar(tester).left, 60);
    expect(bar(tester).top, 80);
  });

  testWidgets(
    'a finished image stays finished when progress is reported late',
    (tester) async {
      await show(tester, (size) => const Rect.fromLTWH(0, 0, 400, 400));
      load.report('full.png', const ImageLoaded());
      load.report('full.png', const ImageLoading());
      await tester.pump();

      expect(load.value, const ImageLoaded());
    },
  );

  testWidgets('a sharper image reports progress after a softer one loaded', (
    tester,
  ) async {
    await show(tester, (size) => const Rect.fromLTWH(0, 0, 400, 400));
    load.report('preview.jpg', const ImageLoaded());
    await tester.pump();
    load.report('full.png', const ImageLoading(0.2));
    await tester.pump();

    expect(load.value, const ImageLoading(0.2));
  });
}
