import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key, this.query});

  final QueryMap? query;

  @override
  Widget build(BuildContext context) => RouterDrawerEntry<TopicsPage>(
    child: FilterControllerProvider(
      create: (_) => TopicFilter(),
      child: ChangeNotifierProvider(
        create: (_) => TopicParamsController(TopicParams.fromQuery(query)),
        child: const TopicsHistoryConnector(
          child: AdaptiveScaffold(
            appBar: DefaultAppBar(
              title: Text('话题'),
              actions: [ContextDrawerButton()],
            ),
            floatingActionButton: TopicSearchFab(),
            drawer: RouterDrawer(),
            endDrawer: TopicListDrawer(),
            body: TopicList(),
          ),
        ),
      ),
    ),
  );
}
