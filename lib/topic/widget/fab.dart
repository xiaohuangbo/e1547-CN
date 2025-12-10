import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class TopicSearchFab extends StatelessWidget {
  const TopicSearchFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TopicController>(
      builder: (context, controller, child) => SearchPromptFloatingActionButton(
        tags: controller.query,
        onSubmit: (value) => controller.query = value,
        filters: [
          WrapperFilterConfig(
            wrapper: (value) => 'search[$value]',
            unwrapper: (value) => value.substring(7, value.length - 1),
            filters: [
              PrimaryFilterConfig(
                filter: const TextFilterTag(tag: 'title_matches', name: 'Name'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
