import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_feeds/model/innovation_model.dart';
import '../../../../components/Banner/banner_m_style_2.dart';
import '../../../../components/dot_indicators.dart';
import '../../../../constants.dart';

class OutstandingCarousel extends StatefulWidget {
  OutstandingCarousel({
    super.key,
    required this.flashInnovations,
  });

  List<InnovationModel> flashInnovations = [];

  @override
  State<OutstandingCarousel> createState() => _OutstandingCarouselState();
}

class _OutstandingCarouselState extends State<OutstandingCarousel> {
  int _selectedIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    if (widget.flashInnovations.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
        if (!mounted) return;

        if (_selectedIndex < widget.flashInnovations.length - 1) {
          _selectedIndex++;
        } else {
          _selectedIndex = 0;
        }

        _pageController.animateToPage(
          _selectedIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flashInnovations.isEmpty) {
      return Container(
        height: 180,
        alignment: Alignment.center,
        child: const Text("No featured innovations yet"),
      );
    }

    return AspectRatio(
      aspectRatio: 1.87,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.flashInnovations.length,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            itemBuilder: (context, index) {
              final innovation = widget.flashInnovations[index];
              return BannerMStyle2(
                title: innovation.title,
                category: innovation.category,
                image: innovation.image,
                press: () {},
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.flashInnovations.length,
                    (index) => Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: DotIndicator(
                    isActive: index == _selectedIndex,
                    activeColor: Colors.white70,
                    inActiveColor: Colors.white54,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}