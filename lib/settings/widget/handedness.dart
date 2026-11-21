import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

enum Handedness {
  left,
  right;

  String get title => switch (this) {
    Handedness.right => 'Right hand',
    Handedness.left => 'Left hand',
  };

  HorizontalDirection get side => switch (this) {
    Handedness.right => HorizontalDirection.right,
    Handedness.left => HorizontalDirection.left,
  };

  FloatingActionButtonLocation get floatingActionButtonLocation =>
      switch (this) {
        Handedness.right => FloatingActionButtonLocation.endFloat,
        Handedness.left => FloatingActionButtonLocation.startFloat,
      };

  static Handedness of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HandednessProvider>()
          ?.notifier
          ?.value ??
      Handedness.right;
}

class HandednessScope extends StatelessWidget {
  const HandednessScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => _HandednessProvider(
    notifier: context.watch<Settings>().handedness,
    child: child,
  );
}

class _HandednessProvider extends InheritedNotifier<ValueNotifier<Handedness>> {
  const _HandednessProvider({required super.notifier, required super.child});
}

class HandednessSettingsTile extends StatelessWidget {
  const HandednessSettingsTile({super.key, required this.state, this.onChange});

  final Handedness state;
  final void Function(Handedness state)? onChange;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('惯用手'),
      subtitle: Text(state.title),
      leading: const Icon(Icons.front_hand),
      onTap: () => showDialog(
        context: context,
        builder: (context) =>
            HandednessDialog(state: state, onChange: onChange),
      ),
    );
  }
}

class HandednessDialog extends StatelessWidget {
  const HandednessDialog({super.key, required this.state, this.onChange});

  final Handedness state;
  final void Function(Handedness state)? onChange;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('惯用手'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: Handedness.values
                .map(
                  (value) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: HandednessOption(
                        value: value,
                        selected: value == state,
                        onTap: () {
                          onChange!(value);
                          Navigator.of(context).maybePop();
                        },
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class HandednessOption extends StatelessWidget {
  const HandednessOption({
    super.key,
    required this.value,
    required this.selected,
    this.onTap,
  });

  final Handedness value;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = theme.colorScheme.secondary;
    final BorderRadius radius = BorderRadius.circular(12);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Material(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(
                color: selected ? accent : theme.dividerColor,
                width: selected ? 2 : 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: Transform.flip(
                  flipX: value == Handedness.left,
                  child: Icon(
                    Icons.front_hand,
                    size: 48,
                    color: selected ? accent : theme.iconTheme.color,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value.title,
          style: selected
              ? theme.textTheme.bodyMedium?.copyWith(color: accent)
              : theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
