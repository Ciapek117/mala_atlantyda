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
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white, width: 2), // Białe obramowanie
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.white, width: 2), // Białe obramowanie przy fokusie
          ),
          hintText: hint,
          hintStyle: TextStyle(color: color),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          label: Text(label, style: TextStyle(color: color)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white, width: 4))),
    );
  }
}
