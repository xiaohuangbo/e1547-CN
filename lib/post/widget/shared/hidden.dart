import 'package:flutter/material.dart';

class HiddenWidget extends StatelessWidget {
  const HiddenWidget({super.key, required this.child, this.show});

  final Widget child;
  final bool? show;

  @override
  Widget build(BuildContext context) =>
      (show ?? true) ? child : const SizedBox();
}
