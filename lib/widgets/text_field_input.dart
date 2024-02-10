import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  bool isPass = false;
  final String hintText;
  final TextInputType textInputType;
  TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: hintText,
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      autocorrect: false,
    );
  }
}
