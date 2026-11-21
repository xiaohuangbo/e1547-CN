import 'dart:typed_data';

import 'package:e1547/shared/shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// The strip is at the outermost physical pixel, so the ratio has to be one
/// that does not divide the logical size evenly.
const double ratio = 2.625;
const double width = 300;
const double height = 100;

void main() {
  final key = GlobalKey();

  /// Mirrors `flutter_test`'s golden capture: the image future starts in the
  /// test zone and is awaited inside [WidgetTester.runAsync].
  Future<List<int>> edgeAlpha(WidgetTester tester) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(key),
    );
    final layer = boundary.debugLayer! as OffsetLayer;
    final image = layer.toImage(boundary.paintBounds, pixelRatio: ratio);
    final (ByteData data, int pixels) = (await tester.runAsync(() async {
      final rendered = await image;
      final bytes = await rendered.toByteData();
      return (bytes!, rendered.width);
    }))!;

    const row = (height * ratio) ~/ 2;
    return List.generate(
      pixels,
      (x) => data.getUint8(((row * pixels) + x) * 4 + 3),
    );
  }

  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.devicePixelRatio = ratio;
    view.physicalSize = const Size(width * ratio, height * ratio);
  });

  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetDevicePixelRatio();
    view.resetPhysicalSize();
  });

  testWidgets('the outermost pixel is masked at a faded edge', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RepaintBoundary(
          key: key,
          // 20 logical times 2.625 lands the row on a half physical pixel,
          // which is what the detail page's padding does.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: width,
              height: height,
              child: ScrollEdgeFade(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: (context, index) => Container(
                    width: 100,
                    height: height,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.drag(
      find.byType(ListView),
      const Offset(-(kTouchSlop + 200), 0),
    );
    await tester.pump();

    final alpha = await edgeAlpha(tester);
    final left = (20 * ratio).floor();
    final right = alpha.length - 1 - left;
    expect(alpha[left], lessThan(8), reason: 'first column of the row');
    expect(alpha[right], lessThan(8), reason: 'last column of the row');
  });
}
