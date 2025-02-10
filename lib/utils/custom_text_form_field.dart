import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final bool obscureText;
  final String errorText;
  final Function(String) onChanged;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.obscureText = false,
    required this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: false,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 0.1,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color:
                    (errorText == '') ? Colors.grey : const Color(0xFFFDA29B),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: (errorText == '')
                    ? const Color(0xFF2F362F)
                    : const Color(0xFFFDA29B),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: onChanged,
        ),
        if (errorText != '')
          Positioned(
            top: 19,
            right: 15,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                errorText,
                style: const TextStyle(
                  color: Color(0xFFFDA29B),
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
