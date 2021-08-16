import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:konoyubi/data/model/asobi.dart';
import 'package:konoyubi/ui/theme/height_width.dart';
import 'package:konoyubi/ui/utility/transition.dart';

import 'asobi_detail_screen.dart';

class AsobiCarousel extends HookWidget {
  const AsobiCarousel({Key? key, required this.asobiList}) : super(key: key);

  final List<Asobi> asobiList;

  @override
  Widget build(BuildContext context) {
    final _current = useState(0);
    final width = useWidth();

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              _current.value = index;
            },
          ),
          items: asobiList.map((asobi) {
            return Builder(
              builder: (BuildContext context) {
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
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Center(
                        child: Text(
                          asobi.title,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
