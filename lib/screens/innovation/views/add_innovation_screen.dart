import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/widgets/dialogs.dart';
import 'package:news_feeds/services/api_service.dart';
import 'package:news_feeds/widgets/widget_helper.dart';
import '../../../components/file_upload_update.dart';
import '../../../route/route_constants.dart';
import '../../../services/DatabaseHelper.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_bottom_nav_bar.dart';

class PostInnovationScreen extends StatefulWidget {
  final DatabaseHelper dbHelper;

  const PostInnovationScreen({super.key, required this.dbHelper});

  @override
  _PostInnovationScreenState createState() => _PostInnovationScreenState();
}

class _PostInnovationScreenState extends State<PostInnovationScreen> {
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
                SizedBox(height: getProportionateScreenHeight(130)),
                Text(
                  "Post an Innovation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(24),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                WidgetHelper().buildTextField(
                  controller: _controller,
                  label: "Innovation Title",
                  placeHolder: "Enter title",
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                WidgetHelper().buildTextField(
                  controller: _controller,
                  label: "Description",
                  maxLines: 5,
                  placeHolder: "Enter description",
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                FileUploadWidget(),
                GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, addedForReviewMessageScreenRoute);
                  },
                  child: Container(
                    height: getProportionateScreenHeight(50),
                    width: screenWidth,
                    margin: EdgeInsets.only(
                      top: getProportionateScreenHeight(40),
                    ),
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
