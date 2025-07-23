import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/services/BaseHelperService.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/widgets/dialogs.dart';
import 'package:news_feeds/widgets/widget_helper.dart';
import 'package:provider/provider.dart';
import '../../../model/innovationDTO.dart';
import '../../../providers/AuthProvider.dart';
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
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  BaseHelperService baseHelperService = BaseHelperService();
  InnovationDTO innovation = InnovationDTO(
    displayImage: '',
    title: '',
    summary: '',
    category: Category.Select,
    authorId: "",
    file: '',
  );
  String? _fileName, _fileNameForDisplayImage;
  PlatformFile? _selectedFile, _selectedFileForDisplayImage;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
        _fileName = _selectedFile!.name;
        innovation.file = _selectedFile!.path;
      });
    }
  }
  Future<void> _pickDisplayImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFileForDisplayImage = result.files.first;
        _fileNameForDisplayImage = _selectedFileForDisplayImage!.name;
        innovation.displayImage = _selectedFileForDisplayImage!.path;
      });
    }
  }

  Future<void> _save() async {
    if (innovation.title!.isEmpty || innovation.summary!.isEmpty) {
        Dialogs.flushBar(context, 'Error', 'Please fill in all fields');
        return;
    }
    Dialogs.loader(context);
    var saveInnovation = await baseHelperService.createInnovation(innovation, _selectedFile, _selectedFileForDisplayImage);
    if(!saveInnovation){
      Navigator.pop(context);
      Dialogs.flushBar(context, 'Error', 'Unable to save innovation');
      return;
    }
    if(mounted){
      Navigator.pop(context);
      Navigator.pushNamed(context, addedForReviewMessageScreenRoute);
      Dialogs.flushBar(context, 'Success', 'Innovation submitted for review');
    } else {
      Dialogs.flushBar(context, 'Error', 'Unable to submit innovation');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<SciKFProvider>(context);
    final user = authProvider.user;
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
                SizedBox(height: getProportionateScreenHeight(100)),
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
                  controller: _titleController,
                  label: "Innovation Title",
                  placeHolder: "Enter title",
                  onChanged: (_) => setState(() {
                    innovation.title = _titleController.text;
                  }),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                WidgetHelper().buildTextField(
                  controller: _summaryController,
                  label: "Description",
                  maxLines: 5,
                  placeHolder: "Enter description",
                  onChanged: (_) => setState(() {
                    innovation.summary = _summaryController.text;
                  }),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                DropdownSearch<Category>(
                  popupProps: PopupProps.menu(showSearchBox: true, fit: FlexFit.loose),
                  dropdownDecoratorProps: WidgetHelper().dropDownDecoratorProps("Category"),
                  items: Category.values,
                  itemAsString: (Category status) => status.displayName,
                  onChanged: (Category? value) {
                    setState(() {
                      innovation.category = value;
                    });
                  },
                  selectedItem: innovation.category,
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                InkWell(
                  onTap: _pickFile,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _fileName ?? "Upload Document/Picture/Research Paper",
                            style: TextStyle(
                              color: _fileName == null ? Colors.grey : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.attach_file, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                InkWell(
                  onTap: _pickDisplayImage,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _fileNameForDisplayImage ?? "Upload Display Picture",
                            style: TextStyle(
                              color: _fileNameForDisplayImage == null ? Colors.grey : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.attach_file, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:() async {
                    innovation.authorId = user!.id;
                    await _save();
                  } ,
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
    _titleController.dispose();
    _summaryController.dispose();
    super.dispose();
  }
}
