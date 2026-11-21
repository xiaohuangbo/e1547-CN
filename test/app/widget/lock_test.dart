import 'package:e1547/app/app.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:notified_preferences/notified_preferences.dart';

import '../../_support/harness.dart';

class FakeLocalAuth extends LocalAuthPlatform {
  FakeLocalAuth({required this.enrolled, this.failure});

  final List<BiometricType> enrolled;
  LocalAuthExceptionCode? failure;
  final List<({bool biometricOnly, String? cancel})> asked = [];

  @override
  Future<bool> authenticate({
    required String localizedReason,
    required Iterable<AuthMessages> authMessages,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    asked.add((
      biometricOnly: options.biometricOnly,
      cancel: authMessages
          .whereType<AndroidAuthMessages>()
          .firstOrNull
          ?.cancelButton,
    ));
    if (failure case final code?) throw LocalAuthException(code: code);
    return true;
  }

  @override
  Future<bool> deviceSupportsBiometrics() async => enrolled.isNotEmpty;

  @override
  Future<List<BiometricType>> getEnrolledBiometrics() async => enrolled;

  @override
  Future<bool> isDeviceSupported() async => true;

  @override
  Future<bool> stopAuthentication() async => true;
}

void main() {
  setUpAll(initializeTestApp);

  late Settings settings;
  late FakeLocalAuth auth;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    settings = await Settings.getInstance();
    auth = FakeLocalAuth(enrolled: [BiometricType.fingerprint]);
    LocalAuthPlatform.instance = auth;
  });

  Future<void> show(
    WidgetTester tester, {
    Duration relockAfter = const Duration(seconds: 30),
  }) async {
    await tester.pumpWidget(
      Provider<Settings>.value(
        value: settings,
        child: MaterialApp(
          home: LockScreen(
            relockAfter: relockAfter,
            child: const Text('inside'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, String pin) async {
    for (final String digit in pin.split('')) {
      await tester.tap(find.text(digit));
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Finder inside() => find.text('inside').hitTestable();

  testWidgets('a wrong PIN says so and the right one opens the app', (
    tester,
  ) async {
    settings.appPin.value = '1234';
    await show(tester);

    await type(tester, '1111');

    expect(find.text('PIN 码错误，请重试。'), findsOneWidget);
    expect(inside(), findsNothing);

    await type(tester, '1234');

    expect(inside(), findsOneWidget);
  });

  testWidgets('a PIN typed on a keyboard opens the app, with Backspace taking '
      'a digit back', (tester) async {
    settings.appPin.value = '1234';
    await show(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit9);
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.sendKeyEvent(LogicalKeyboardKey.numpad3);
    await tester.sendKeyEvent(LogicalKeyboardKey.numpad4);
    await tester.pumpAndSettle();

    expect(inside(), findsOneWidget);
  });

  testWidgets('a wide window has the title beside the keys, which keep their '
      'width', (tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    settings.appPin.value = '1234';
    await show(tester);

    final Rect title = tester.getRect(find.text('输入 PIN 码'));
    final Rect one = tester.getRect(find.text('1'));
    final Rect three = tester.getRect(find.text('3'));
    expect(title.right, lessThan(one.left));
    expect(three.right - one.left, lessThan(400));
  });

  testWidgets('a tall window has the title above the keys', (tester) async {
    tester.view.physicalSize = const Size(500, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    settings.appPin.value = '1234';
    await show(tester);

    final Rect title = tester.getRect(find.text('输入 PIN 码'));
    final Rect one = tester.getRect(find.text('1'));
    expect(title.bottom, lessThan(one.top));
    expect(title.center.dx, closeTo(250, 1));
  });

  testWidgets('a short wide screen puts the title beside the keys and keeps '
      'every key on it', (tester) async {
    tester.view.physicalSize = const Size(800, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    settings.appPin.value = '1234';
    await show(tester);

    final Rect title = tester.getRect(find.text('输入 PIN 码'));
    final Rect one = tester.getRect(find.text('1'));
    final Rect zero = tester.getRect(find.text('0'));
    expect(title.right, lessThan(one.left));
    expect(one.top, greaterThanOrEqualTo(0));
    expect(zero.bottom, lessThanOrEqualTo(360));

    await type(tester, '1234');

    expect(inside(), findsOneWidget);
  });

  testWidgets('a screen too small for either layout shrinks the pad to fit', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 380);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    settings.appPin.value = '1234';
    await show(tester);

    final Rect title = tester.getRect(find.text('输入 PIN 码'));
    final Rect zero = tester.getRect(find.text('0'));
    expect(title.top, greaterThanOrEqualTo(0));
    expect(title.bottom, lessThan(tester.getRect(find.text('1')).top));
    expect(zero.bottom, lessThanOrEqualTo(380));

    await type(tester, '1234');

    expect(inside(), findsOneWidget);
  });

  testWidgets('Escape leaves the PIN chooser with nothing chosen', (
    tester,
  ) async {
    String? chosen = 'unset';
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => chosen = await choosePin(context),
            child: const Text('go'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    expect(find.text('创建 PIN 码'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(chosen, isNull);
    expect(find.text('go').hitTestable(), findsOneWidget);
  });

  testWidgets(
    'a canceled fingerprint falls back to the PIN pad, whose fingerprint key '
    'asks again',
    (tester) async {
      settings.appPin.value = '1234';
      settings.biometricAuth.value = true;
      auth.failure = LocalAuthExceptionCode.userCanceled;
      await show(tester);

      expect(auth.asked, [(biometricOnly: true, cancel: '使用 PIN')]);
      expect(find.text('输入 PIN 码'), findsOneWidget);

      auth.failure = null;
      await tester.tap(find.bySemanticsLabel('指纹'));
      await tester.pumpAndSettle();

      expect(auth.asked, hasLength(2));
      expect(inside(), findsOneWidget);
    },
  );

  testWidgets('a canceled fingerprint lock waits with Unlock', (tester) async {
    settings.biometricAuth.value = true;
    auth.failure = LocalAuthExceptionCode.userCanceled;
    await show(tester);

    expect(auth.asked.single.cancel, '取消');
    expect(find.text('解锁'), findsOneWidget);
    expect(inside(), findsNothing);

    auth.failure = null;
    await tester.tap(find.text('解锁'));
    await tester.pumpAndSettle();

    expect(inside(), findsOneWidget);
  });

  testWidgets('too many tries offers the phone screen lock', (tester) async {
    settings.biometricAuth.value = true;
    auth.failure = LocalAuthExceptionCode.temporaryLockout;
    await show(tester);

    expect(find.text('尝试次数过多，请在 30 秒后重试。'), findsOneWidget);

    auth.failure = null;
    await tester.tap(find.text('使用屏幕锁'));
    await tester.pumpAndSettle();

    expect(auth.asked.last.biometricOnly, isFalse);
    expect(inside(), findsOneWidget);
  });

  Future<void> away(WidgetTester tester) async {
    for (final AppLifecycleState state in const [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await tester.pumpAndSettle();
  }

  testWidgets('the app locks again after being away for the relock time', (
    tester,
  ) async {
    settings.appPin.value = '1234';
    await show(tester, relockAfter: Duration.zero);
    await type(tester, '1234');
    expect(inside(), findsOneWidget);

    await away(tester);

    expect(inside(), findsNothing);
    expect(find.text('输入 PIN 码'), findsOneWidget);
  });

  testWidgets('a trip away shorter than the relock time keeps it open', (
    tester,
  ) async {
    settings.appPin.value = '1234';
    await show(tester, relockAfter: const Duration(hours: 1));
    await type(tester, '1234');

    await away(tester);

    expect(inside(), findsOneWidget);
  });

  testWidgets('choosing a PIN asks twice and starts over on a mismatch', (
    tester,
  ) async {
    String? chosen;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => chosen = await choosePin(context),
            child: const Text('go'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.text('创建 PIN 码'), findsOneWidget);
    await type(tester, '1234');
    expect(find.text('确认您的 PIN 码'), findsOneWidget);
    await type(tester, '5678');

    expect(find.text('两次输入不一致'), findsOneWidget);
    expect(find.text('创建 PIN 码'), findsOneWidget);

    await type(tester, '2468');
    await type(tester, '2468');

    expect(chosen, '2468');
  });

  testWidgets('a fingerprint the phone cannot read offers the screen lock', (
    tester,
  ) async {
    settings.biometricAuth.value = true;
    auth.failure = LocalAuthExceptionCode.noBiometricsEnrolled;
    await show(tester);

    expect(find.text('指纹不可用，请改用屏幕锁。'), findsOneWidget);
    expect(find.text('使用屏幕锁'), findsOneWidget);
  });

  testWidgets('a long fingerprint lockout offers the screen lock', (
    tester,
  ) async {
    settings.biometricAuth.value = true;
    auth.failure = LocalAuthExceptionCode.biometricLockout;
    await show(tester);

    expect(find.text('尝试次数过多，请改用屏幕锁。'), findsOneWidget);
    expect(find.text('使用屏幕锁'), findsOneWidget);
  });
}
