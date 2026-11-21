import 'package:collection/collection.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'params.freezed.dart';

enum TopicOrder {
  sticky('sticky'),
  newest('id_desc'),
  oldest('id_asc');

  const TopicOrder(this.value);

  final String value;
}

enum TopicCategory {
  general(1),
  siteBugReportsAndFeatureRequests(11),
  tagWikiProjectsAndQuestions(10),
  tagAliasAndImplicationSuggestions(2),
  artTalk(3),
  offTopic(5),
  e621ToolsAndApplications(9);

  const TopicCategory(this.id);

  final int id;
}

@freezed
abstract class TopicParams with _$TopicParams {
  const factory TopicParams({
    String? title,
    TopicCategory? category,
    @Default(TopicOrder.sticky) TopicOrder order,
    bool? sticky,
    bool? locked,
  }) = _TopicParams;

  const TopicParams._();

  factory TopicParams.fromQuery(QueryMap? query) {
    if (query == null) return const TopicParams();
    return TopicParams(
      title: query['search[title_matches]'],
      category: TopicCategory.values.firstWhereOrNull(
        (c) => c.id.toString() == query['search[category_id]'],
      ),
      order:
          TopicOrder.values.firstWhereOrNull(
            (o) => o.value == query['search[order]'],
          ) ??
          TopicOrder.sticky,
      sticky: _parseBool(query['search[is_sticky]']),
      locked: _parseBool(query['search[is_locked]']),
    );
  }

  static const titleFilter = TextFilterTag(
    tag: 'search[title_matches]',
    name: '标题包含',
  );

  static final categoryFilter = EnumFilterTag<TopicCategory>(
    tag: 'search[category_id]',
    name: 'Category',
    values: TopicCategory.values,
    valueMapper: (value) => value.id.toString(),
    nameMapper: (value) => switch (value) {
      TopicCategory.general => 'General',
      TopicCategory.siteBugReportsAndFeatureRequests =>
        'Site Bug Reports & Feature Requests',
      TopicCategory.tagWikiProjectsAndQuestions =>
        'Tag/Wiki Projects and Questions',
      TopicCategory.tagAliasAndImplicationSuggestions =>
        'Tag Alias and Implication Suggestions',
      TopicCategory.artTalk => 'Art Talk',
      TopicCategory.offTopic => 'Off Topic',
      TopicCategory.e621ToolsAndApplications => 'e621 Tools and Applications',
    },
    undefinedOption: const EnumFilterNullTagValue(),
  );

  static final orderFilter = EnumFilterTag<TopicOrder>(
    tag: 'search[order]',
    name: 'Sort by',
    values: TopicOrder.values,
    valueMapper: (value) => value.value,
    nameMapper: (value) => switch (value) {
      TopicOrder.sticky => 'Default',
      TopicOrder.newest => 'Newest first',
      TopicOrder.oldest => 'Oldest first',
    },
  );

  static const stickyFilter = BooleanFilterTag(
    tag: 'search[is_sticky]',
    name: 'Sticky',
    description: '置顶',
    tristate: true,
  );

  static const lockedFilter = BooleanFilterTag(
    tag: 'search[is_locked]',
    name: 'Locked',
    description: '锁定',
    tristate: true,
  );

  QueryMap toQuery() => <String, Object?>{
    'search[title_matches]': title,
    'search[category_id]': category?.id,
    if (order != TopicOrder.sticky) 'search[order]': order.value,
    'search[is_sticky]': sticky,
    'search[is_locked]': locked,
  }.toQuery();
}

bool? _parseBool(String? value) => switch (value) {
  'true' => true,
  'false' => false,
  _ => null,
};

class TopicParamsController extends ValueNotifier<TopicParams> {
  TopicParamsController([TopicParams? initial])
    : super(initial ?? const TopicParams());

  void update(TopicParams Function(TopicParams) updater) =>
      value = updater(value);
}
