import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class TopicSearchFab extends StatelessWidget {
  const TopicSearchFab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TopicParamsController>();
    return SearchPromptFab(
      tags: controller.value.toQuery(),
      onSubmit: (value) => controller.value = TopicParams.fromQuery(value),
      filters: [
        PrimaryFilterConfig(
          filter: TopicParams.titleFilter,
          filters: [
            TopicParams.categoryFilter,
            TopicParams.orderFilter,
            TopicParams.stickyFilter,
            TopicParams.lockedFilter,
          ],
        ),
      ],
    );
  }
}
