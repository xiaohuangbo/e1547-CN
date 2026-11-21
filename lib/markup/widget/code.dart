import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CodeWrap extends StatelessWidget {
  const CodeWrap({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredCard(
      backgroundColor: Theme.of(context).canvasColor,
      color: dimTextColor(context),
      padding: const EdgeInsets.only(left: ColoredCard.stripeWidth),
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(
          context,
        ).style.copyWith(fontFamily: 'JetBrains Mono'),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [child],
          ),
        ),
      ),
    );
  }
}
