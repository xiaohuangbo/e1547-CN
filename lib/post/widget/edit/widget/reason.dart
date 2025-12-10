import 'package:e1547/ticket/ticket.dart';
import 'package:flutter/material.dart';

class EditReasonDisplay extends StatelessWidget {
  const EditReasonDisplay({super.key, required this.controller, this.enabled});

  final TextEditingController controller;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultFormPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Edit reason (optional)', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Why are you editing this post?',
            ),
            enabled: enabled,
          ),
        ],
      ),
    );
  }
}
