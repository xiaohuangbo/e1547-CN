import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class TopicTagEditingTile extends StatelessWidget {
  const TopicTagEditingTile({super.key, required this.controller});

  final TopicController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => SwitchListTile(
        secondary: const Icon(Icons.inventory_outlined),
        title: const Text('隐藏标签编辑'),
        subtitle: Text(
          controller.hideTagEditing
              ? '隐藏标签别名和含义'
              : '显示标签别名和含义',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        value: controller.hideTagEditing,
        onChanged: (value) => controller.hideTagEditing = value,
      ),
    );
  }
}
