import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
import 'select_tag_screen.dart';

final initialDateTime =
    DateTime(2021, DateTime.now().month, DateTime.now().day, 4, 00);
final startTimeProvider = StateProvider((ref) => initialDateTime);
final endTimeProvider = StateProvider((ref) => initialDateTime);

class SelectAsobiDatetimeScreen extends HookWidget {
  const SelectAsobiDatetimeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final l10n = useL10n(context);
    final startTime = useProvider(startTimeProvider);
    final endTime = useProvider(endTimeProvider);

    bool _validation({
      required BuildContext context,
      required DateTime start,
      required DateTime end,
    }) {
      final isStartSpecified = start != initialDateTime;
      final isEndSpecified = end != initialDateTime;
      final isStartBeforeEnd = start.isBefore(end);

      if (!isStartSpecified) {
        showPrimaryDialog(context: context, content: l10n.inputStart);
      } else if (!isEndSpecified) {
        showPrimaryDialog(context: context, content: l10n.inputEnd);
      } else if (!isStartBeforeEnd) {
        showPrimaryDialog(context: context, content: l10n.endMustBeAfterStart);
      }

      return isStartSpecified && isEndSpecified && isStartBeforeEnd;
    }

    return CreateAsobiScreenTemplate(
      title: l10n.decideTime,
      body: Body(
        start: startTime,
        end: endTime,
      ),
      index: 3,
      onBack: () {
        Navigator.pop(context);
      },
      onNext: () {
        final isValid = _validation(
          context: context,
          start: startTime.state,
          end: endTime.state,
        );

        if (isValid) {
          pageTransition(
            context: context,
            to: const SelectAsobiTagScreen(),
          );
        }
      },
    );
  }
}

void dateTimePicker({
  required BuildContext context,
  required StateController<DateTime> timeState,
}) {
  showDatePicker(
    context: context,
    initialDate: timeState.state,
    firstDate: DateTime.now(),
    lastDate: DateTime(
        DateTime.now().year + 1, DateTime.now().month, DateTime.now().day - 1),
  ).then(
    (date) {
      showTimePicker(context: context, initialTime: TimeOfDay.now()).then(
        (time) {
          timeState.state = DateTime(
            date!.year,
            date.month,
            date.day,
            time!.hour,
            time.minute,
          );
        },
      );
    },
  );
}

class Body extends HookWidget {
  const Body({
    Key? key,
    required this.start,
    required this.end,
  }) : super(key: key);

  final StateController<DateTime> start;
  final StateController<DateTime> end;

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n(context);
    final startTime = start.state == initialDateTime
        ? l10n.undecided
        : start.state.toString().substring(0, 16);
    final endTime = end.state == initialDateTime
        ? l10n.undecided
        : end.state.toString().substring(0, 16);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 4),
          Component(
            title: l10n.decideStart,
            time: startTime,
            onSelect: () {
              dateTimePicker(context: context, timeState: start);
            },
          ),
          const Spacer(),
          Component(
            title: l10n.decideEnd,
            time: endTime,
            onSelect: () {
              dateTimePicker(context: context, timeState: end);
            },
          ),
          const Spacer(flex: 6),
        ],
      ),
    );
  }
}

class Component extends StatelessWidget {
  const Component({
    Key? key,
    required this.title,
    required this.time,
    required this.onSelect,
  }) : super(key: key);

  final String title;
  final String time;
  final void Function()? onSelect;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Text(title),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.only(left: width * 0.1),
              width: width * 0.6,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Text(
                time,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: width * 0.052),
              ),
            ),
            ElevatedButton(
              onPressed: onSelect,
              child: const Icon(Icons.edit, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
