import 'dart:io';

import 'package:e1547/account/account.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class AvailabilityCheck extends StatefulWidget {
  const AvailabilityCheck({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<AvailabilityCheck> createState() => _AvailabilityCheckState();
}

class _AvailabilityCheckState extends State<AvailabilityCheck> {
  final Logger logger = Logger('ClientAvailability');

  @override
  void initState() {
    super.initState();
    check(context);
  }

  Future<void> check(BuildContext context) async {
    bool? offerResolve;
    final client = context.read<Client>();
    final identities = context.read<IdentityClient>();
    final Logger scope = logger.child({'host': client.host});
    try {
      await client.accounts.available();
      scope.info('Client is available');
    } on ClientException catch (e, stacktrace) {
      if (CancelToken.isCancel(e)) {
        scope.debug('Availability check cancelled');
        return;
      }
      if (isCloudflareChallenge(e.response)) {
        scope.warn('Behind a Cloudflare challenge, resolving');
        await dropCloudflareCookies(identities);
        offerResolve = true;
      } else {
        int? statusCode = e.response?.statusCode;
        if (statusCode == null) return;
        switch (statusCode) {
          case HttpStatus.forbidden:
            scope.warn('Client denied access ({status}), failing silently', {
              'status': statusCode,
            });
            // This could potentially logout the user.
            // However, it might be returned during Cloudflare API blockages.
            // Logout the user, and if theyre already logged out, trigger Resolver?
            break;
          case >= 500 && < 600:
            scope.warn('Client unavailable ({status}), cannot resolve', {
              'status': statusCode,
            });
            offerResolve = false;
            break;
          default:
            scope.warn(
              'Availability check failed ({status})',
              {'status': statusCode},
              e,
              stacktrace,
            );
        }
      }
    }

    if (offerResolve case final bool offerResolve) {
      widget.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => HostUnavailablePage(offerResolve: offerResolve),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
