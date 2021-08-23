import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/create_asobi_screen_template.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/utility/primary_dialog.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
import 'confirm_asobi_screen.dart';

final selectedTagProvider = StateProvider<List<String>>((ref) => []);

class SelectAsobiTagScreen extends HookWidget {
  const SelectAsobiTagScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final selectedTag = useProvider(selectedTagProvider);
    final l10n = useL10n();

    bool _validation({
      required List<String> selectedTag,
      required BuildContext context,
    }) {
      final isBlank = selectedTag.isEmpty;
      if (isBlank) {
        showPrimaryDialog(
            context: context, content: l10n.selectTagMoreThanZero);
      }

      return !isBlank;
    }

    return CreateAsobiScreenTemplate(
      title: l10n.addTag,
      body: const Body(),
      index: 4,
      onBack: () {
        Navigator.pop(context);
      },
      onNext: () {
        final isValid = _validation(
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
    );
  }
}

class Body extends HookWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = useL10n();

    List<String> asobiTagList = [
      l10n.karaoke,
      l10n.shopping,
      l10n.sport,
      l10n.talk,
      l10n.havingTea,
      l10n.meal,
    ];
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
    final isSelected = useState(selectedTag.state.contains(tag));
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
