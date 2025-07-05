import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/widgets/dialogs.dart';
import '../services/api_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_suffix_icon.dart';
import '../widgets/widget_helper.dart';
import 'home/Components/news_detail_screen.dart';

class PromptScreen extends StatefulWidget {
  @override
  _PromptScreenState createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  String? _response;

  @override
  Widget build(BuildContext context) {
    double screenWidth = SizeConfig.screenWidth;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(fullName: "User", isOnline: true),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(getProportionateScreenHeight(10)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(10)),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(30)),
                Text(
                  "Ask Anything",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(24),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                Text(
                  "Have a question or need help with something?\nJust type it below and we'll do the rest.",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: getProportionateScreenHeight(15), color: Colors.grey[700]),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                TextFormField(
                  cursorColor: kPrimaryColor,
                  maxLines: 4,
                  controller: _controller,
                  decoration: WidgetHelper().buildInputDecoration("Prompt", "Enter text"),
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: getProportionateScreenHeight(300)),
                GestureDetector(
                  onTap:() async {
                    Dialogs.loader(context);
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _response = null;
                    });
                    try {
                      final responseData =
                      await _apiService.answerPrompt(_controller.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailScreen(newsItem: responseData),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  child: Container(
                    height: getProportionateScreenHeight(50),
                    width: screenWidth,
                    margin: EdgeInsets.only(top: getProportionateScreenHeight(40)),
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          custom_suffix_icon(
                            svgIcon: "assets/icons/Send.svg",
                            color: Colors.white,
                          ),
                          SizedBox(width: getProportionateScreenWidth(2)),
                          Text(
                            "Submit prompt",
                            style: TextStyle(
                              letterSpacing: 2,
                              fontWeight: FontWeight.w800,
                              fontSize: getProportionateScreenWidth(17),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
      bottomNavigationBar: CustomBottomNavBar()
    );
  }
}