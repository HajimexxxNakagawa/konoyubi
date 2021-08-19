import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'select_tag_screen.dart';

final initialDateTime =
    DateTime(2021, DateTime.now().month, DateTime.now().day, 4, 00);
final startTimeProvider = StateProvider((ref) => initialDateTime);
final endTimeProvider = StateProvider((ref) => initialDateTime);

class SelectAsobiDatetimeScreen extends HookWidget {
  const SelectAsobiDatetimeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final startTime = useProvider(startTimeProvider);
    final endTime = useProvider(endTimeProvider);

    return CreateAsobiScreenTemplate(
      title: 'ジカンを決める',
      body: Body(
        start: startTime,
        end: endTime,
      ),
      index: 3,
      onBack: () {
        Navigator.pop(context);
      },
      onNext: () {
        final isValid = timeValidation(
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

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.start,
    required this.end,
  }) : super(key: key);

  final StateController<DateTime> start;
  final StateController<DateTime> end;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                dateTimePicker(context: context, timeState: start);
              },
              child: const Text("集合時間を決める")),
          Text(start.state == initialDateTime
              ? "未定"
              : start.state.toString().substring(0, 16)),
          ElevatedButton(
              onPressed: () {
                dateTimePicker(context: context, timeState: end);
              },
              child: const Text("終了時間を決める")),
          Text(end.state == initialDateTime
              ? "未定"
              : end.state.toString().substring(0, 16)),
        ],
      ),
    );
  }
}

bool timeValidation({
  required BuildContext context,
  required DateTime start,
  required DateTime end,
}) {
  final isStartSpecified = start != initialDateTime;
  final isEndSpecified = end != initialDateTime;
  final isStartBeforeEnd = start.isBefore(end);

  if (!isStartSpecified) {
    showPrimaryDialog(context: context, content: "集合時間を入力してね！");
  } else if (!isEndSpecified) {
    showPrimaryDialog(context: context, content: "終了時間を入力してね！");
  } else if (!isStartBeforeEnd) {
    showPrimaryDialog(context: context, content: "終了時間は集合時間より後にしてね！");
  }

  return isStartSpecified && isEndSpecified && isStartBeforeEnd;
}
