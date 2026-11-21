import 'dart:io';

import 'package:e1547/account/account.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class HostUnavailablePage extends StatelessWidget {
  const HostUnavailablePage({super.key, this.offerResolve = false});

  final bool offerResolve;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(child: AppBar(leading: const CloseButton())),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 60),
              const SizedBox(height: 8),
              Text(
                'Host unavailable',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'It appears that ${linkToDisplay(context.watch<Client>().host)} is not available!',
              ),
              const SizedBox(height: 16),
              if (offerResolve && (Platform.isAndroid || Platform.isIOS)) ...[
                const Text(
                  '请在以下浏览器窗口中解决问题。'
                  '\n\nCloudflare 验证 Cookie 将被保存。',
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const CookieCapturePage(),
                    ),
                  ),
                  child: const Text('解决'),
                ),
              ] else
                Dimmed(
                  child: Text(
                    '\nPlease wait for ${linkToDisplay(context.watch<Client>().host)} to resolve the situation on their end.',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
