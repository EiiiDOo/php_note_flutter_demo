import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hint,
    required this.textEditingController,
    required this.valid,
  });
  final String hint;
  final TextEditingController textEditingController;
  final String? Function(String?) valid;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      validator: valid,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
