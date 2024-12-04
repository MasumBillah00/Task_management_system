import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final String? validatorMessage;

  const CustomTextField({
    Key? key,
     this.label,
     this.controller,
    this.validatorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
        border: OutlineInputBorder(
          borderRadius:  BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),

      ),
      validator: validatorMessage != null ? (value) => value!.isEmpty ? validatorMessage : null : null,
    );
  }
}
