import 'package:e1547/markup/markup.dart';
import 'package:flutter/material.dart';

/// Render a DText `[table]` or `[ltable]` AST node. Uses Flutter's stock [Table]
/// widget with one [TableRow] per parsed row, normalising column counts so
/// short rows do not throw a `Different number of children` assertion.
class DTextTableWidget extends StatelessWidget {
  const DTextTableWidget({super.key, required this.children});

  final List<DTextTableChild> children;

  @override
  Widget build(BuildContext context) {
    final rows = <_RenderedRow>[];
    void visit(List<DTextTableChild> nodes, {required bool inHead}) {
      for (final node in nodes) {
        switch (node) {
          case DTextTableHead(rows: final inner):
            visit(inner, inHead: true);
          case DTextTableBody(rows: final inner):
            visit(inner, inHead: false);
          case DTextTableRow(cells: final cells):
            rows.add(_RenderedRow(cells: cells, isHead: inHead));
          case DTextTableLiteral():
            break;
        }
      }
    }

    visit(children, inHead: false);
    if (rows.isEmpty) return const SizedBox.shrink();

    final columns = rows
        .map((r) => r.cells.length)
        .reduce((a, b) => a > b ? a : b);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(color: Theme.of(context).dividerColor),
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              for (final row in rows)
                TableRow(
                  decoration: row.isHead
                      ? BoxDecoration(color: Theme.of(context).hoverColor)
                      : null,
                  children: [
                    for (var i = 0; i < columns; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: i < row.cells.length
                            ? ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constraints.maxWidth,
                                ),
                                child: DTextInlineSpans(
                                  children: row.cells[i].children,
                                  isHeader:
                                      row.cells[i].cellType ==
                                      DTextTableCellType.th,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RenderedRow {
  const _RenderedRow({required this.cells, required this.isHead});

  final List<DTextTableCell> cells;
  final bool isHead;
}

/// Render a list of inline nodes inside a table cell as a single rich text
/// block.
class DTextInlineSpans extends StatelessWidget {
  const DTextInlineSpans({
    super.key,
    required this.children,
    this.isHeader = false,
  });

  final List<DTextInline> children;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final inner = DTextBody(content: DTextParagraph(children));
    if (!isHeader) return inner;
    return DefaultTextStyle.merge(
      style: const TextStyle(fontWeight: FontWeight.bold),
      child: inner,
    );
  }
}
