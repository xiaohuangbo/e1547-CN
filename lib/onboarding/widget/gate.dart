import 'package:e1547/onboarding/onboarding.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class OnboardingGate extends StatelessWidget {
  const OnboardingGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: context.watch<Settings>().onboardingSeen,
    builder: (context, seen, _) => seen ? child : const OnboardingScreen(),
  );
}
