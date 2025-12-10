import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class HistorySearchFab extends StatelessWidget {
  const HistorySearchFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryController>(
      builder: (context, controller, child) => FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () async {
          final client = context.read<Client>();
          Locale locale = Localizations.localeOf(context);

          // TODO: Wrap this around the widget as a Future
          // awaiting this here means the UI might not react immediately
          List<DateTime> days = await client.histories.days();
          if (days.isEmpty) {
            days.add(DateTime.now());
          }

          if (!context.mounted) return;

          HistoryQuery search = HistoryQuery.from(controller.search);

          DateTime? result = await showDatePicker(
            context: context,
            initialDate: search.date ?? DateTime.now(),
            firstDate: days.first,
            lastDate: days.last,
            locale: locale,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            selectableDayPredicate: (value) =>
                days.any((e) => DateUtils.isSameDay(value, e)),
          );

          if (!context.mounted) return;
          ScrollController scrollController = PrimaryScrollController.of(
            context,
          );

          if (result != search.date) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                0,
                duration: defaultAnimationDuration,
                curve: Curves.easeInOut,
              );
            }

            controller.search = search.copy()..date = result;
          }
        },
      ),
    );
  }
}
