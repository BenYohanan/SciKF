import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../services/api_service.dart';
import '/size_config.dart';
import 'components/splash_content.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  Future<void> _fetchData() async {
    await ApiService().fetchScienceNews();
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus(context,);
    });

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: SplashContent(
                image: "assets/img/icon.png",
                text: "",
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(1, (index) => buildDot(index: index)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkLoginStatus(BuildContext context) async {
    try {
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      Navigator.pushReplacementNamed(context, '/auth_type');
    }
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: 20,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}