import 'package:e1547/query/query.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/widgets.dart';

// This is not great. It doesnt allow copying the entire value easily.
typedef TopicFilterValue = ({bool hideTagEditing});

class TopicFilter extends FilterController<Topic>
    implements ValueNotifier<TopicFilterValue> {
  TopicFilter([TopicFilterValue? value])
    : _value = value ?? (hideTagEditing: true);

  TopicFilterValue _value;

  @override
  TopicFilterValue get value => _value;

  @override
  set value(TopicFilterValue value) {
    if (_value == value) return;
    _value = value;
    notifyListeners();
  }

  @override
  Object idOf(Topic item) => item.id;

  // TODO: remove this and implement fetching AIBUR inside dtext
  @override
  bool filter(Topic item) =>
      !value.hideTagEditing ||
      item.categoryId != TopicCategory.tagAliasAndImplicationSuggestions.id;
}
