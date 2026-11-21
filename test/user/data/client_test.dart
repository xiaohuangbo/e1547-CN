import 'package:e1547/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/client.dart';
import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  late FakeE621 fake;
  late UserClient client;

  setUpAll(initializeTestApp);

  setUp(() async {
    fake = await FakeE621.start();
    client = UserClient(dio: dioFor(fake));
  });

  tearDown(() => fake.stop());

  test('maps a recorded user onto the model', () async {
    final recorded = loadFixtureList('users.json').first;

    final user = await client.get(id: recorded['id']! as int);

    expect(user.id, recorded['id']);
    expect(user.name, recorded['name']);
    expect(user.stats?.levelString, recorded['level_string']);
  });

  test('reads a user by name', () async {
    final recorded = loadFixtureList('users.json').first;

    final user = await client.getByName(name: recorded['name']! as String);

    expect(user.id, recorded['id']);
  });
}
