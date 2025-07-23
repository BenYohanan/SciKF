import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_feeds/size_config.dart';
import 'package:provider/provider.dart';

import '../../../components/dot_indicators.dart';
import '../../../constants.dart';
import '../../../providers/SciKFProvider.dart';
import '../../../route/route_constants.dart';
import 'components/onbording_content.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  final List<Onbord> _onboardData = [
    Onbord(
      icon: "assets/icons/SearchGlobe.svg",
      title: "Discover Cutting-Edge Science",
      description:
          "Explore a vast collection of articles, and courses on topics like astronomy, biology, and AI, curated for curious minds.",
    ),
    Onbord(
      icon: "assets/icons/Research.svg",
      title: "Stay Updated with Breakthroughs",
      description:
          "Get the latest scientific discoveries and innovations delivered straight to your feed, personalized to your interests.",
    ),
    Onbord(
      icon: "assets/icons/Science.svg",
      title: "Tailor Your Science Journey",
      description:
          "Customize your feed with topics like physics, biotech, or environmental science to match your interests.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<SciKFProvider>(context, listen: false);
      authProvider.loadUserData().then((_) {
        if (authProvider.user != null) {
          Navigator.pushReplacementNamed(context, mainScreenRoute);
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, logInScreenRoute);
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenHeight(16),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardData.length,
                  onPageChanged: (value) {
                    setState(() {
                      _pageIndex = value;
                    });
                  },
                  itemBuilder: (context, index) => OnbordingContent(
                    title: _onboardData[index].title,
                    description: _onboardData[index].description,
                    icon: _onboardData[index].icon,
                    isTextOnTop: index.isOdd,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    _onboardData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: defaultPadding / 4),
                      child: DotIndicator(isActive: index == _pageIndex),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pageIndex < _onboardData.length - 1) {
                          _pageController.nextPage(
                            curve: Curves.ease,
                            duration: defaultDuration,
                          );
                        } else {
                          Navigator.pushNamed(context, logInScreenRoute);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Arrow - Right.svg",
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}

class Onbord {
  final String icon, title, description;

  Onbord({required this.icon, required this.title, this.description = ""});
}
