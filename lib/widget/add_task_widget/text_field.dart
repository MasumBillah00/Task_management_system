import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? validatorMessage;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.validatorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      validator: validatorMessage != null ? (value) => value!.isEmpty ? validatorMessage : null : null,
    );
  }
}
