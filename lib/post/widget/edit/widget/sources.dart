import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:flutter/material.dart';

class SourcesEditDisplay extends StatelessWidget {
  const SourcesEditDisplay({
    super.key,
    required this.postId,
    required this.controller,
    this.enabled,
  });

  final int postId;
  final TextEditingController controller;
  final bool? enabled;

  @override
  Widget build(BuildContext context) => Padding(
    padding: defaultFormPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Sources', style: TextStyle(fontSize: 16)),
            ),
            IconButton(
              onPressed: (enabled ?? true)
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TextEditor(
                            title: Text('#$postId sources'),
                            content: controller.text,
                            onSubmitted: (text) {
                              controller.text = text;
                              return null;
                            },
                            onClosed: Navigator.of(context).maybePop,
                          ),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            final sources = controller.text
                .split('\n')
                .where((s) => s.trim().isNotEmpty)
                .toList();

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: sources.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sources
                          .map(
                            (source) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: SourceCard(url: source),
                            ),
                          )
                          .toList(),
                    )
                  : Text(
                      'No sources',
                      style: TextStyle(
                        color: dimTextColor(context),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
            );
          },
        ),
      ],
    ),
  );
}
