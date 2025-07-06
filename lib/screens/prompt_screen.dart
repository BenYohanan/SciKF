import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/widgets/dialogs.dart';
import 'package:news_feeds/services/api_service.dart';
import 'package:news_feeds/widgets/custom_app_bar.dart';
import 'package:news_feeds/widgets/custom_bottom_nav_bar.dart';
import 'package:news_feeds/widgets/custom_suffix_icon.dart';
import 'package:news_feeds/widgets/widget_helper.dart';
import '../services/DatabaseHelper.dart';
import 'home/Components/news_detail_screen.dart';

class PromptScreen extends StatefulWidget {
  final DatabaseHelper dbHelper;
  const PromptScreen({super.key, required this.dbHelper});

  @override
  _PromptScreenState createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final TextEditingController _controller = TextEditingController();
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(widget.dbHelper);
  }

  Future<void> _submitPrompt() async {
    if (_controller.text.isEmpty) {
      Dialogs.flushBar(context, "Error", 'Please enter a prompt');
      return;
    }

    Dialogs.loader(context);
    FocusScope.of(context).unfocus();

    try {
      final responseData = await _apiService.answerPrompt(_controller.text);
      Navigator.of(context, rootNavigator: true).pop(); // Close loader
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailScreen(newsItem: responseData),
        ),
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Close loader
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

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
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(15),
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                TextFormField(
                  cursorColor: kPrimaryColor,
                  maxLines: 7,
                  controller: _controller,
                  decoration: WidgetHelper().buildInputDecoration("Prompt", "Enter text"),
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: getProportionateScreenHeight(250)),
                GestureDetector(
                  onTap: _submitPrompt,
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
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}