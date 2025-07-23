import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class WidgetHelper {
  Widget buildStyledModalButton({
    required String text,
    required VoidCallback onPressed,
    required double fontSize,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  String stripHtml(String? htmlString) {
    if (htmlString == null || htmlString.isEmpty) return '';
    return htmlString.replaceAll(RegExp(r'<[^>]+>'), '');
  }

  DropDownDecoratorProps dropDownDecoratorProps(String labelText) {
    return DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        labelText: labelText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
        labelStyle: TextStyle(
          color: primaryColor,
          fontSize: getProportionateScreenHeight(14),
        ),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(String? labelText, String? hintText) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: const OutlineInputBorder(),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontStyle: FontStyle.italic,
      ),
      labelStyle: TextStyle(
        color: Colors.grey.shade700,
        fontSize: getProportionateScreenHeight(14),
      ),
    );
  }

  bool checkIfIsLabourOrTravel(String partName) {
    if(partName.isEmpty){
      return true;
    }else{
      if(partName.toLowerCase() == "labour" || partName.toLowerCase() == "travel" ){
        return false;
      }
      return true;
    }
  }

  Widget buildDropdown<T>({
    required String label,
    required List<T> items,
    required T? value,
    required Function(T?) onChanged,
    required String Function(T) itemAsString,
    required Widget Function(T) itemBuilder,
    String? Function(T?)? validator,
  }) {
    return DropdownSearch<T>(
      popupProps: PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose
      ),
      dropdownDecoratorProps: dropDownDecoratorProps(label),
      selectedItem: value,
      items: items,
      itemAsString: itemAsString,
      dropdownBuilder: (context, selectedItem) =>
      selectedItem != null ? itemBuilder(selectedItem) : const SizedBox(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget buildTextField({
    required String label,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool readOnly = false,
    Function(String)? onChanged,
    Function()? onTap,
    int maxLines = 1,
    String? Function(String?)? validator,
    String? placeHolder
  }) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onChanged: onChanged,
      onTap: onTap,
      maxLines: maxLines,
      cursorColor: primaryColor,
      decoration: buildInputDecoration(label, placeHolder),
      validator: validator,

    );
  }
}

mixin BaseUrlChecker<T extends StatefulWidget> on State<T> {
  String? baseUrl;
  bool _hasCheckedBaseUrl = false;

  void checkBaseUrl() {
    if (_hasCheckedBaseUrl || !mounted) return;
    _hasCheckedBaseUrl = true;
    if (baseUrl == null || baseUrl!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/auth_type');
        }
      });
    }
  }
}
