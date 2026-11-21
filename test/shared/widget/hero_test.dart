import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const double tall = 0.25;
const Key art = ValueKey('art');

void main() {
  Widget side(Size size, BoxFit fit) => Align(
    alignment: Alignment.topLeft,
    child: SizedBox.fromSize(
      size: size,
      child: ContentHero(
        tag: 'art',
        content: FittedContent(fit: fit, aspectRatio: tall),
        child: const ColoredBox(key: art, color: Color(0xFF000000)),
      ),
    ),
  );

  Future<NavigatorState> host(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: side(const Size(200, 240), BoxFit.cover)),
      ),
    );
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(
        builder: (context) =>
            Scaffold(body: side(const Size(800, 400), BoxFit.contain)),
      ),
    );
    await tester.pump();
    await tester.pump();
    return navigator;
  }

  bool flying() => find
      .ancestor(of: find.byKey(art), matching: find.byType(Positioned))
      .evaluate()
      .isNotEmpty;

  (Rect, Rect) flight(WidgetTester tester) => (
    tester.getRect(find.byKey(art)),
    tester.getRect(
      find.ancestor(of: find.byKey(art), matching: find.byType(Stack)).first,
    ),
  );

  Future<(Rect, Rect)> landing(WidgetTester tester) async {
    (Rect, Rect) last = flight(tester);
    while (flying()) {
      last = flight(tester);
      await tester.pump(const Duration(milliseconds: 4));
    }
    return last;
  }

  Matcher near(double value) => closeTo(value, 2);

  testWidgets('a push starts cropped in the tile and ends letterboxed', (
    tester,
  ) async {
    await host(tester);
    final (Rect image, Rect box) = flight(tester);
    expect(image.width, near(box.width));
    expect(image.height, near(box.width / tall));
    expect(image.center.dy, near(box.center.dy));

    final (Rect landed, Rect bounds) = await landing(tester);
    expect(landed.height, near(bounds.height));
    expect(landed.width, near(bounds.height * tall));
    expect(landed.center.dx, near(bounds.center.dx));
  });

  testWidgets('a pop starts letterboxed and ends cropped in the tile', (
    tester,
  ) async {
    final NavigatorState navigator = await host(tester);
    await tester.pumpAndSettle();
    navigator.pop();
    await tester.pump();
    await tester.pump();

    final (Rect image, Rect box) = flight(tester);
    expect(image.height, near(box.height));
    expect(image.width, near(box.height * tall));

    final (Rect landed, Rect bounds) = await landing(tester);
    expect(bounds.size.width, near(200));
    expect(landed.width, near(bounds.width));
    expect(landed.height, near(bounds.width / tall));
  });

  testWidgets('keeps the proportions through the flight', (tester) async {
    await host(tester);
    await tester.pump(const Duration(milliseconds: 150));
    final (Rect image, Rect _) = flight(tester);
    expect(image.width / image.height, closeTo(tall, 0.001));
  });

  test('fitted content places the image the way the fit paints it', () {
    const Size box = Size(200, 240);
    expect(
      const FittedContent(fit: BoxFit.cover, aspectRatio: tall).locate(box),
      const Rect.fromLTWH(0, -280, 200, 800),
    );
    expect(
      const FittedContent(fit: BoxFit.contain, aspectRatio: tall).locate(box),
      const Rect.fromLTWH(70, 0, 60, 240),
    );
    expect(
      const FittedContent(fit: BoxFit.contain, aspectRatio: null).locate(box),
      isNull,
    );
  });
}
