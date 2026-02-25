import 'package:flutter/material.dart';

import '../util/spacing.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const AppTextField({super.key, required this.controller, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
