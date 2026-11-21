import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class SectionWrap extends StatelessWidget {
  const SectionWrap({
    required Key super.key,
    required this.child,
    this.title,
    this.expanded = false,
  });

  final Widget child;
  final String? title;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return ColoredCard(
      backgroundColor: Theme.of(context).canvasColor,
      color: dimTextColor(context),
      padding: const EdgeInsets.only(left: ColoredCard.stripeWidth),
      child: ExpandablePanel(
        controller: Expandables.of(context, key!, expanded: expanded),
        header: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title?.replaceAll(RegExp(r'\s+'), ' ').trim() ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        collapsed: const SizedBox.shrink(),
        expanded: Padding(
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
