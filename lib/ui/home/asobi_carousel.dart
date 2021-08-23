import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:konoyubi/auth/user.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/components/typography.dart';
import 'package:konoyubi/ui/createAsobi/input_name_screen.dart';
import 'package:konoyubi/ui/theme/constants.dart';
import 'package:konoyubi/ui/theme/height_width.dart';
import 'package:konoyubi/ui/utility/transition.dart';
import 'package:konoyubi/ui/utility/use_l10n.dart';
import 'asobi_detail_screen.dart';

class AsobiCarousel extends HookWidget {
  const AsobiCarousel({Key? key, required this.asobiList}) : super(key: key);

  final List<Asobi> asobiList;

  @override
  Widget build(BuildContext context) {
    final _current = useState(0);
    // アソビ開始時間でソート
    asobiList.sort((a, b) => a.start.compareTo(b.start));

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: asobiList.length != 1,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              _current.value = index;
            },
          ),
          items: asobiList.map((asobi) {
            return Builder(
              builder: (BuildContext context) {
                return AsobiCarouselCard(asobi: asobi);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class AsobiCarouselCard extends HookWidget {
  const AsobiCarouselCard({Key? key, required this.asobi}) : super(key: key);

  final Asobi asobi;

  @override
  Widget build(BuildContext context) {
    final start = asobi.start.toString().substring(0, 16);
    final end = asobi.end.toString().substring(0, 16);
    final width = useWidth();

    return GestureDetector(
      onTap: () {
        showModalWithFadeAnimation(
          context: context,
          to: AsobiDetailScreen(asobi),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: width,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              H1(asobi.title),
              Body1(asobi.description),
              const SizedBox(height: 4),
              Column(
                children: [
                  Body1('ハジマリ：' + start),
                  Body1('シメキリ：' + end),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentlyOpeningMyAsobi extends StatelessWidget {
  const CurrentlyOpeningMyAsobi({
    Key? key,
    required this.entries,
  }) : super(key: key);

  final List<Asobi> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const AsobiEmptyCard();
    }

    return AsobiCarousel(asobiList: entries);
  }
}

class AsobiEmptyCard extends HookWidget {
  const AsobiEmptyCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = useProvider(firebaseAuthProvider);
    final isSignedIn = currentUser.data?.value != null;
    final width = useWidth();
    final l10n = useL10n();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: bodyColor,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        height: width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Body1(l10n.noYourAsobi, color: Colors.white),
            ActionText(
              l10n.letsCreateAsobi,
              onPressed: () {
                if (!isSignedIn) {
                  promptSignIn(context);
                } else {
                  showModal(
                    context: context,
                    modal: const InputAsobiNameScreen(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
