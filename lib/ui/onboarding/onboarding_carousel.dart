import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/ui/theme/height_width.dart';

class OnboardingCarousel extends HookWidget {
  const OnboardingCarousel({Key? key}) : super(key: key);

  static const List<String> _onbordings = [
    'マップからアソビを探そう！',
    '主催者にリクエストを出そう！',
    'チャットで予定を調整しよう！',
    '楽しくアソビに出かけよう！',
    '自分でアソビを募集してみよう！',
  ];

  @override
  Widget build(BuildContext context) {
    final _current = useState(0);
    final height = useHeight();

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: height * 0.7,
            onPageChanged: (index, reason) {
              _current.value = index;
            },
          ),
          items: _onbordings.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 5.0),
                  child: Material(
                    color: Colors.white,
                    elevation: 6,
                    borderRadius: BorderRadius.circular(16),
                    child: Center(child: Text(item)),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _onbordings.asMap().entries.map((entry) {
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
