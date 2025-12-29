import 'package:e1547/interface/interface.dart';
import 'package:flutter/material.dart';

extension GridQuiltDescription on GridQuilt {
  String get description {
    switch (this) {
      case GridQuilt.square:
        return '格子是方形的';
      case GridQuilt.vertical:
        return '格子垂直扩展';
    }
  }

  IconData get icon {
    switch (this) {
      case GridQuilt.square:
        return Icons.view_module;
      case GridQuilt.vertical:
        return Icons.view_column;
    }
  }
}

class GridSettingsTile extends StatelessWidget {
  const GridSettingsTile({super.key, required this.state, this.onChange});

  final GridQuilt state;
  final void Function(GridQuilt state)? onChange;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('瀑布流'),
      subtitle: Text(state.description),
      leading: Icon(state.icon),
      onTap: () => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('网格'),
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: GridQuilt.values
                  .map(
                    (state) => ListTile(
                      trailing: Icon(state.icon),
                      title: Text(state.description),
                      onTap: () {
                        onChange!(state);
                        Navigator.of(context).maybePop();
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
