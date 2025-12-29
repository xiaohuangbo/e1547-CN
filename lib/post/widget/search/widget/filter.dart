import 'package:e1547/interface/interface.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class PostsPageFloatingActionButton extends StatelessWidget {
  const PostsPageFloatingActionButton({super.key, required this.controller});

  final PostController controller;

  @override
  Widget build(BuildContext context) {
    return SearchPromptFloatingActionButton(
      tags: controller.query,
      onSubmit: (value) => controller.query = value,
      filters: [
        PrimaryFilterConfig(
          filter: TagSearchFilterTag(tag: 'tags', name: '标签'),
          filters: [
            NestedFilterTag(
              tag: 'tags',
              decode: TagMap.new,
              encode: (value) => TagMap.from(value).toString(),
              filters: const [
                NumberRangeFilterTag(
                  tag: 'score',
                  name: '分数',
                  min: 0,
                  max: 100,
                  division: 10,
                  initial: NumberRange(
                    20,
                    comparison: NumberComparison.greaterThanOrEqual,
                  ),
                  icon: Icon(Icons.arrow_upward),
                ),
                NumberRangeFilterTag(
                  tag: 'favcount',
                  name: '收藏数量',
                  min: 0,
                  max: 100,
                  division: 10,
                  initial: NumberRange(
                    20,
                    comparison: NumberComparison.greaterThanOrEqual,
                  ),
                  icon: Icon(Icons.favorite),
                ),
                ChoiceFilterTag(
                  tag: 'order',
                  name: '排序方式',
                  icon: Icon(Icons.sort),
                  options: [
                    ChoiceFilterTagValue(value: null, name: '默认'),
                    ChoiceFilterTagValue(value: 'new', name: '最新'),
                    ChoiceFilterTagValue(value: 'score', name: '分数'),
                    ChoiceFilterTagValue(value: 'favcount', name: '收藏'),
                    ChoiceFilterTagValue(value: 'rank', name: '排名'),
                    ChoiceFilterTagValue(value: 'random', name: '随机'),
                  ],
                ),
                ChoiceFilterTag(
                  tag: 'rating',
                  name: '分级',
                  icon: Icon(Icons.question_mark),
                  options: [
                    ChoiceFilterTagValue(value: null, name: '全部'),
                    ChoiceFilterTagValue(value: 's', name: '安全'),
                    ChoiceFilterTagValue(value: 'q', name: '问题'),
                    ChoiceFilterTagValue(value: 'e', name: '露骨'),
                  ],
                ),
                ToggleFilterTag(
                  tag: 'inpool',
                  name: '图集',
                  enabled: 'true',
                  disabled: 'false',
                  description: '有图集',
                ),
                ToggleFilterTag(
                  tag: 'ischild',
                  name: '子帖',
                  enabled: 'true',
                  disabled: 'false',
                  description: '是子帖',
                ),
                ToggleFilterTag(
                  tag: 'isparent',
                  name: '父帖',
                  enabled: 'true',
                  disabled: 'false',
                  description: '是父帖',
                ),
                ChoiceFilterTag(
                  tag: 'date',
                  name: '上传日期',
                  icon: Icon(Icons.date_range),
                  options: [
                    ChoiceFilterTagValue(value: null, name: '全部'),
                    ChoiceFilterTagValue(value: 'day', name: '最近一天'),
                    ChoiceFilterTagValue(value: 'week', name: '最近一周'),
                    ChoiceFilterTagValue(value: 'month', name: '最近一月'),
                    ChoiceFilterTagValue(value: 'year', name: '最近一年'),
                  ],
                ),
                ChoiceFilterTag(
                  tag: 'status',
                  name: '状态',
                  icon: Icon(Icons.help),
                  options: [
                    ChoiceFilterTagValue(value: null, name: '默认'),
                    ChoiceFilterTagValue(value: 'active', name: '活动'),
                    ChoiceFilterTagValue(value: 'pending', name: '待定'),
                    ChoiceFilterTagValue(value: 'deleted', name: '已删除'),
                    ChoiceFilterTagValue(value: 'flagged', name: '已标记'),
                    ChoiceFilterTagValue(value: 'any', name: '任何'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
