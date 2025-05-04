import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, this.label, this.textStyle,this.hintText, this.obscureText, this.validator, required this.controller, this.keyboardType});
  final String? label;
  final String? hintText;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: textStyle,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      obscuringCharacter: obscureText! ? '*' : '\u2022',
      validator: validator,
      decoration: InputDecoration(
        label: Text(label!),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
