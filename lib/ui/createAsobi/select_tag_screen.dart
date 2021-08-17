import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'confirm_asobi_screen.dart';

final absorbStateProvider = StateProvider((ref) => false);
final selectedTagProvider = StateProvider<List<String>>((ref) => []);
final asobiTagProvider = StateProvider((ref) => '');
enum AsobiTag { karaoke, shopping, sports, talk, cafe, meal }
const List<String> asobiTagList = [
  'カラオケ',
  'カイモノ',
  'スポーツ',
  'オシャベリ',
  'オチャ',
  'オショクジ',
];

class SelectAsobiTagScreen extends HookWidget {
  const SelectAsobiTagScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isAbsorb = useProvider(absorbStateProvider);
    final selectedTag = useProvider(selectedTagProvider);

    return AbsorbPointer(
      absorbing: isAbsorb.state,
      child: CreateAsobiScreenTemplate(
        title: 'タグを付ける',
        body: const Body(),
        index: 4,
        onBack: () {
          Navigator.pop(context);
        },
        onNext: () {
          final isValid = asobiTagValidation(
            context: context,
            selectedTag: selectedTag.state,
          );
          if (isValid) {
            pageTransition(
              context: context,
              to: const ConfirmAsobiScreen(),
            );
          }
        },
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Wrap(
          spacing: 10,
          children:
              asobiTagList.map((asobiTag) => TagButton(tag: asobiTag)).toList(),
        ),
      ),
    );
  }
}

class TagButton extends HookWidget {
  const TagButton({Key? key, required this.tag}) : super(key: key);
  final String tag;

  @override
  Widget build(BuildContext context) {
    final selectedTag = useProvider(selectedTagProvider);
    final isSelected = useState(false);
    return OutlinedButton(
      onPressed: () {
        isSelected.value = !isSelected.value;
        toggleTag(selectedTag: selectedTag.state, key: tag);
      },
      child: Body1(tag, color: isSelected.value ? Colors.white : bodyColor),
      style: ElevatedButton.styleFrom(
        primary: isSelected.value ? accentColor : Colors.white,
      ),
    );
  }
}

void toggleTag({
  required List<String> selectedTag,
  required String key,
}) {
  if (!selectedTag.remove(key)) {
    selectedTag.add(key);
  }
}

bool asobiTagValidation({
  required List<String> selectedTag,
  required BuildContext context,
}) {
  final isBlank = selectedTag.isEmpty;
  if (isBlank) {
    showPrimaryDialog(context: context, content: '1つ以上タグを選んでね！');
  }

  return !isBlank;
}
