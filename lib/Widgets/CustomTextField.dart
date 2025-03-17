import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
        required this.hint,
        required this.label,
        this.controller,
        required this.color,
        this.isPassword = false});
  final String hint;
  final String label;
  final bool isPassword;
  final Color color;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: color),
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: color),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          label: Text(label, style: TextStyle(color: color)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.yellow, width: 4))),
    );
  }
}
