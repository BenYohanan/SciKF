import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/widgets/dialogs.dart';
import 'package:news_feeds/services/PromptService.dart';
import 'package:news_feeds/components/custom_app_bar.dart';
import 'package:news_feeds/components/custom_bottom_nav_bar.dart';
import 'package:news_feeds/widgets/widget_helper.dart';
import '../../../components/loader.dart';
import '../../../services/DatabaseHelper.dart';
import 'news_detail_screen.dart';

class PromptScreen extends StatefulWidget {
  final DatabaseHelper dbHelper;
  const PromptScreen({super.key, required this.dbHelper});

  @override
  _PromptScreenState createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final TextEditingController _controller = TextEditingController();
  late final PromptService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = PromptService(widget.dbHelper);
  }

  Future<void> _submitPrompt() async {
    if (_controller.text.isEmpty) {
      Dialogs.flushBar(context, "Error", 'Please enter a prompt');
      return;
    }

    AppLoader.show(context);
    FocusScope.of(context).unfocus();

    try {
      final responseData = await _apiService.answerPrompt(_controller.text);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailScreen(newsItem: responseData),
        ),
      );
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Dialogs.flushBar(context, "Error", 'Please enter a prompt');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = SizeConfig.screenWidth;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
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
                  "Ask Scinexa",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(24),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                Text(
                  'Ask Scinexa questions about inventions in Healthcare, Agriculture, and Health Sciences. Scinexa is currently tailored to address questions in these aforementioned domains.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(15),
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                TextFormField(
                  cursorColor: primaryColor,
                  maxLines: 10,
                  controller: _controller,
                  decoration: WidgetHelper().buildInputDecoration("Prompt", "Enter text"),
                  onChanged: (_) => setState(() {}),
                ),
                GestureDetector(
                  onTap: _submitPrompt,
                  child: Container(
                    height: getProportionateScreenHeight(50),
                    width: screenWidth,
                    margin: EdgeInsets.only(top: getProportionateScreenHeight(40)),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Submit",
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
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}