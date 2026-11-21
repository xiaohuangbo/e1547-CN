// Block-level conformance: every block node kind in the AST is exercised
// against the e621ng/dtext reference (oracled via the dmark proxy). Inputs
// and frozen expected JSON live in `fixtures/blocks.json`; regenerate with
// `./test/markup/regenerate.sh blocks` whenever inputs change.

import '_support/fixtures.dart';

void main() => runFixtures('blocks');
