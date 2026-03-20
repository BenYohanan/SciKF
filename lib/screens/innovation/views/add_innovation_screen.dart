import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  ConsumerState<PostInnovationScreen> createState() =>
      _PostInnovationScreenState();
}

class _PostInnovationScreenState
    extends ConsumerState<PostInnovationScreen> {
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

  PlatformFile? _selectedFile;
  File? _selectedImageFile;

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
    final picker = ImagePicker();

    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxWidth: 1024,
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImageFile = File(pickedImage.path);
        _fileNameForDisplayImage = pickedImage.name;
        innovation.displayImage = pickedImage.path;
      });
    }
  }

  Future<void> _save() async {
    if (innovation.title!.isEmpty || innovation.summary!.isEmpty) {
      Dialogs.flushBar(context, 'Error', 'Please fill in all fields');
      return;
    }

    AppLoader.show(context);

    var success = await baseHelperService.createInnovation(
      innovation,
      _selectedFile,
      _selectedImageFile,
    );

    Navigator.pop(context);

    if (!success) {
      Dialogs.flushBar(context, 'Error', 'Unable to save innovation');
      return;
    }

    if (mounted) {
      await baseHelperService.reloadData(ref, innovation.authorId!);
      Navigator.pushNamed(context, addedForReviewMessageScreenRoute);
      Dialogs.flushBar(
          context, 'Success', 'Innovation submitted for review');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(sciKFProvider);
    final user = authProvider.user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(getProportionateScreenHeight(10)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
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
                  onChanged: (_) {
                    innovation.title = _titleController.text;
                  },
                ),

                SizedBox(height: getProportionateScreenHeight(15)),

                DropdownSearch<Category>(
                  compareFn: (a, b) => a == b,
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                  ),
                  decoratorProps:
                  WidgetHelper().dropDownDecoratorProps("Category"),
                  items: (filter, _) {
                    if (filter.isEmpty) return Category.values;

                    return Category.values
                        .where((c) => c.displayName
                        .toLowerCase()
                        .contains(filter.toLowerCase()))
                        .toList();
                  },
                  itemAsString: (c) => c.displayName,
                  onChanged: (value) {
                    innovation.category = value;
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

                // ✅ IMAGE PREVIEW
                if (_selectedImageFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImageFile!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Positioned(
                          right: 5,
                          top: 5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImageFile = null;
                                _fileNameForDisplayImage = null;
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.close,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: getProportionateScreenHeight(15)),

                WidgetHelper().buildTextField(
                  controller: _summaryController,
                  label: "Description",
                  maxLines: 4,
                  placeHolder: "Enter description",
                  onChanged: (_) {
                    innovation.summary = _summaryController.text;
                  },
                ),

                SizedBox(height: getProportionateScreenHeight(20)),

                WidgetHelper().buildModernButtonWithIcon(
                  text: 'Submit',
                  color: primaryColor,
                  svgName: "Send.svg",
                  onPressed: () async {
                    if (_selectedFile == null ||
                        _selectedImageFile == null) {
                      Dialogs.flushBar(context, 'Error',
                          'Please upload both document and display image');
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