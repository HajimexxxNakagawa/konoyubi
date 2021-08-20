import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/ui/components/typography.dart';

class OnboardingCarousel extends HookWidget {
  const OnboardingCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _current = useState(0);

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: 320,
            onPageChanged: (index, reason) {
              _current.value = index;
            },
          ),
          items: [1, 2, 3].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 5.0),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: OnboardingItem(
                        itemNumber: i,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 2, 3].asMap().entries.map((entry) {
            return GestureDetector(
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current.value == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    Key? key,
    required this.itemNumber,
  }) : super(key: key);

  final int itemNumber;

  @override
  Widget build(BuildContext context) {
    switch (itemNumber) {
      case 1:
        return H1("アカウントを作成しましょう！");
      case 2:
        return H1("アソビを募集しましょう！");
      default:
        return H1("オーナーにチャットしましょう！");
    }
  }
}
