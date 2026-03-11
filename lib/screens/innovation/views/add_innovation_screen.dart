import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_feeds/constants.dart';
import 'package:news_feeds/services/BaseHelperService.dart';
import 'package:news_feeds/size_config.dart';
import 'package:news_feeds/widgets/dialogs.dart';
import 'package:news_feeds/widgets/widget_helper.dart';
import '../../../components/loader.dart';
import '../../../model/innovationDTO.dart';
import '../../../providers/sci_kf_notifier.dart';
import '../../../route/route_constants.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_bottom_nav_bar.dart';

class PostInnovationScreen extends ConsumerStatefulWidget {

  const PostInnovationScreen({super.key});
  ConsumerState<PostInnovationScreen> createState() => _PostInnovationScreenState();
}

class _PostInnovationScreenState extends ConsumerState<PostInnovationScreen> {
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
      type: FileType.any,
      withData: kIsWeb,
      withReadStream: !kIsWeb,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
        _fileName = _selectedFile!.name;
        innovation.file = _selectedFile!.path ?? '';
      });
    }
  }

  Future<void> _pickDisplayImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: kIsWeb,
      withReadStream: !kIsWeb,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFileForDisplayImage = result.files.first;
        _fileNameForDisplayImage = _selectedFileForDisplayImage!.name;
        innovation.displayImage = _selectedFileForDisplayImage!.path ?? '';
      });
    }
  }
  Future<void> _save() async {
    if (innovation.title!.isEmpty || innovation.summary!.isEmpty) {
        Dialogs.flushBar(context, 'Error', 'Please fill in all fields');
        return;
    }
    AppLoader.show(context);
    var saveInnovation = await baseHelperService.createInnovation(innovation, _selectedFile, _selectedFileForDisplayImage);
    if(!saveInnovation){
      Navigator.pop(context);
      Dialogs.flushBar(context, 'Error', 'Unable to save innovation');
      return;
    }
    if(mounted){
      await baseHelperService.reloadData(ref, innovation.authorId!);
      Navigator.pop(context);
      Navigator.pushNamed(context, addedForReviewMessageScreenRoute);
      Dialogs.flushBar(context, 'Success', 'Innovation submitted for review');
    } else {
      Dialogs.flushBar(context, 'Error', 'Unable to submit innovation');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(sciKFProvider);
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
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  "Post an Innovation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(24),
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                WidgetHelper().buildTextField(
                  controller: _titleController,
                  label: "Title",
                  placeHolder: "Enter title",
                  onChanged: (_) => setState(() {
                    innovation.title = _titleController.text;
                  }),
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                DropdownSearch<Category>(
                  compareFn: (Category a, Category b) => a == b,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        labelText: 'Search Category',
                        labelStyle: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: getProportionateScreenHeight(14)),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)),
                      ),
                    ),
                  ),
                  decoratorProps: WidgetHelper().dropDownDecoratorProps("Category"),
                  items: (filter, _) {
                    if (filter.isEmpty) return Category.values;

                    return Category.values
                        .where((c) => c.displayName
                        .toLowerCase()
                        .contains(filter.toLowerCase()))
                        .toList();
                  },
                  itemAsString: (Category status) => status.displayName,
                  onChanged: (Category? value) {
                    setState(() {
                      innovation.category = value;
                    });
                  },
                  selectedItem: innovation.category,
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
               WidgetHelper().buildUploadField(
                  label: "Research Document",
                  placeHolder: "Upload document / research paper",
                  fileName: _fileName,
                  onTap: _pickFile,
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                WidgetHelper().buildUploadField(
                  label: "Display Image",
                  placeHolder: "Upload display image",
                  fileName: _fileNameForDisplayImage,
                  onTap: _pickDisplayImage,
                  icon: Icons.image,
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                WidgetHelper().buildTextField(
                  controller: _summaryController,
                  label: "Description",
                  maxLines: 4,
                  placeHolder: "Enter description",
                  onChanged: (_) => setState(() {
                    innovation.summary = _summaryController.text;
                  }),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                WidgetHelper().buildModernButtonWithIcon(
                  text: 'Submit',
                  color: primaryColor,
                  svgName: "Send.svg",
                  onPressed: () async{
                    if (_selectedFile == null || _selectedFileForDisplayImage == null) {
                      Navigator.pop(context);
                      Dialogs.flushBar(context, 'Error', 'Please upload both document and display image');
                      return;
                    }
                    innovation.authorId = user!.id;
                    await _save();
                  },
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
