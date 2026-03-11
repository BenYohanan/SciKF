import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  Widget buildUploadField({
    required String label,
    required String? fileName,
    required Function() onTap,
    String? placeHolder,
    IconData icon = Icons.upload_file,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: buildInputDecoration(label, placeHolder),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                fileName ?? placeHolder ?? "Upload file",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: fileName == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
            Icon(icon, color: primaryColor),
          ],
        ),
      ),
    );
  }
  Widget buildModernButtonWithIcon({
    required String text,
    required Color color,
    String? svgName,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: svgName != null
          ? SvgPicture.asset(
        "assets/icons/$svgName",
        color: Colors.white,
        height: getProportionateScreenHeight(20),
      )
          : const SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        textStyle: TextStyle(fontSize: getProportionateScreenHeight(16), fontWeight: FontWeight.w600),
      ),
    );
  }
  DropDownDecoratorProps dropDownDecoratorProps(String labelText) {
    return DropDownDecoratorProps(
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: labelText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
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
}

