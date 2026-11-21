import 'package:flutter/material.dart';

/// Heading above a group of rows.
///
/// [indent] aligns the title with whatever the rows put on their left.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.indent = 16});

  /// Lines the title up with the title column of a [ListTile] that has a
  /// leading widget.
  static const double listTileIndent = 72;

  final String title;
  final double indent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(indent, 8, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
