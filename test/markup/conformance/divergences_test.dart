// Pinned divergences from the staging-corpus fuzz against dmark. Every
// entry is marked `skip` with a short root-cause description so the
// suite documents the bug without breaking CI. Removing the `skip`
// field (in `fixtures/divergences.json`) is the signal that the
// underlying bug has been fixed and the test should start enforcing
// parity. Regenerate frozen JSON with
// `./test/markup/regenerate.sh divergences`.

import '_support/fixtures.dart';

void main() => runFixtures('divergences');
