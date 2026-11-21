import 'dart:io';

import 'package:e1547/account/account.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('withoutCloudflareCookies', () {
    test('strips Cloudflare cookies and keeps the rest', () {
      expect(
        withoutCloudflareCookies({
          HttpHeaders.cookieHeader:
              'cf_clearance=dead; _danbooru_session=keep; __cfruid=dead',
        }),
        {HttpHeaders.cookieHeader: '_danbooru_session=keep'},
      );
    });

    test('removes the header when only Cloudflare cookies remain', () {
      expect(
        withoutCloudflareCookies({
          HttpHeaders.authorizationHeader: 'Basic secret',
          HttpHeaders.cookieHeader: 'cf_clearance=dead',
        }),
        {HttpHeaders.authorizationHeader: 'Basic secret'},
      );
    });

    test('returns null when there is nothing to strip', () {
      expect(
        withoutCloudflareCookies({
          HttpHeaders.cookieHeader: '_danbooru_session=keep',
        }),
        null,
      );
      expect(withoutCloudflareCookies({}), null);
      expect(withoutCloudflareCookies(null), null);
    });

    test('keeps values containing separators intact', () {
      expect(
        withoutCloudflareCookies({
          HttpHeaders.cookieHeader: 'cf_clearance=dead; session=a=b=c',
        }),
        {HttpHeaders.cookieHeader: 'session=a=b=c'},
      );
    });
  });
}
