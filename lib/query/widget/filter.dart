import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class FilterControllerProvider<C extends FilterController<T>, T>
    extends SubListenableProvider0<C> {
  // ignore: use_key_in_widget_constructors
  FilterControllerProvider({
    required super.create,
    super.child,
    TransitionBuilder? builder,
    super.keys,
  }) : super(
         builder: (context, child) =>
             // Also provide the generic version to allow [QueryFilter] to access the controller
             ListenableProvider<FilterController<T>>.value(
               value: context.read<C>(),
               builder: builder,
               child: child,
             ),
       );

  // ignore: use_key_in_widget_constructors
  FilterControllerProvider.value({
    required C value,
    super.child,
    TransitionBuilder? builder,
  }) : super(
         create: (_) => value,
         keys: (_) => [value],
         builder: (context, child) =>
             ListenableProvider<FilterController<T>>.value(
               value: context.read<C>(),
               builder: builder,
               child: child,
             ),
       );
}

typedef FilterableState<T, K> = InfiniteQueryStatus<List<T>, K>;

class QueryFilter<T, K> extends StatefulWidget {
  const QueryFilter({super.key, required this.state, required this.builder});

  final FilterableState<T, K> state;
  final Widget Function(BuildContext context, FilterableState<T, K> state)
  builder;

  @override
  State<QueryFilter<T, K>> createState() => _QueryFilterState<T, K>();
}

class _QueryFilterState<T, K> extends State<QueryFilter<T, K>> {
  final Object _key = Object();
  FilterController<T>? _controller;

  @override
  void dispose() {
    _controller?.untrack(_key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FilterController<T>?>();
    if (!identical(_controller, controller)) {
      _controller?.untrack(_key);
      _controller = controller;
    }

    final data = widget.state.data;
    if (data == null || controller == null) {
      return widget.builder(context, widget.state);
    }

    final pages = data.pages;
    final flat = pages.expand((p) => p).toList();
    final filtered = controller.track(_key, flat);
    final filteredIds = filtered.map(controller.idOf).toSet();
    final rechunked = pages
        .map(
          (page) => page
              .where((item) => filteredIds.contains(controller.idOf(item)))
              .toList(),
        )
        .toList();

    return widget.builder(
      context,
      widget.state.copyWithData(
        InfiniteQueryData(pages: rechunked, args: data.args),
      ),
    );
  }
}
