import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../route/route_constants.dart';
import '../../../services/BaseHelperService.dart';
import '../../../size_config.dart';
import 'components/customSuffixIcon.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _emailController = TextEditingController();
  final _service = BaseHelperService();
  final FocusNode _emailFocus = FocusNode();
  final List<String> _errors = [];
  @override
  Widget build(BuildContext context) {
    final screenWidth = SizeConfig.screenWidth;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(20)),
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "Forget Password?",
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(20),
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(3)),
                    Text(
                      "Enter the password used during account creation and a reset link will be sent",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(14),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    _buildEmailFormField(),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: getProportionateScreenHeight(50),
                        width: screenWidth,
                        margin: EdgeInsets.only(top: getProportionateScreenHeight(20)),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Reset.svg",
                                height: getProportionateScreenWidth(18),
                                color: Colors.white,
                              ),
                              SizedBox(width: getProportionateScreenWidth(10)),
                              Text(
                                "Request reset link",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Back to"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, logInScreenRoute);
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: getProportionateScreenHeight(14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _addError({required String error}) {
    if (!_errors.contains(error)) {
      setState(() => _errors.add(error));
    }
  }
  void _removeError({required String error}) {
    if (_errors.contains(error)) {
      setState(() => _errors.remove(error));
    }
  }
  Widget _buildEmailFormField() {
    return TextFormField(
      cursorColor: primaryColor,
      controller: _emailController,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _removeError(error: kEmailNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          _addError(error: kEmailNullError);
          return kEmailNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(
          color: textColor,
          fontSize: getProportionateScreenWidth(14),
          fontWeight: FontWeight.w600,
        ),
        labelText: "Email",
        hintText: "Enter active email",
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
          color: primaryColor,
        ),
      ),
    );
  }
}
