// Link conformance: bare URLs, textile links, wiki links, post-search
// links, id links across every IdType, internal anchors, and link-in-text
// contexts. Inputs and frozen expected JSON live in `fixtures/links.json`;
// regenerate with `./test/markup/regenerate.sh links`.

import '_support/fixtures.dart';

void main() => runFixtures('links');
