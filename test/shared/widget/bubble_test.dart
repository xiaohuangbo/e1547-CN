import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const double width = 400;
  const double margin = 16;

  Widget overlay({required bool shown, EdgeInsets padding = EdgeInsets.zero}) =>
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: const Size(width, 800), padding: padding),
          child: BubbleOverlay(
            bubbles: [
              if (shown)
                const OverlayBubble(
                  id: 'bubble',
                  size: 40,
                  child: SizedBox.square(dimension: 40, key: Key('bubble')),
                ),
            ],
            child: const SizedBox.expand(),
          ),
        ),
      );

  testWidgets('a bubble left out through a resize returns to its edge', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(overlay(shown: true));
    await tester.pumpWidget(
      overlay(shown: false, padding: const EdgeInsets.only(top: 24)),
    );
    await tester.pumpWidget(
      overlay(shown: true, padding: const EdgeInsets.only(top: 24)),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getTopRight(find.byKey(const Key('bubble'))).dx,
      width - margin,
    );
  });
}
