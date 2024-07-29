import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? prefixText;
  // Controller
  final TextEditingController? controller;

  // Validator
  final FormFieldValidator<String>? validator;

  // Text Input Formatter
  final List<TextInputFormatter>? inputFormat;

  // Text Input Type
  final TextInputType? inputType;
  final Widget? trailing;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  final bool isVisible;
  const InputField({
    super.key,
    this.label = "label name",
    this.icon,
    this.validator,
    this.controller,
    this.inputFormat,
    this.inputType,
    this.trailing,
    this.isVisible = false,
    this.prefixText,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        validator: validator,
        controller: controller,
        inputFormatters: inputFormat,
        keyboardType: inputType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: isVisible,
        decoration: InputDecoration(
          label: Text(label),
          hintText: label,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixText: prefixText,
          prefixStyle: const TextStyle(fontSize: 16, color: Colors.black),
          prefixIcon: prefixText == null ? Icon(icon) : null,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(.3), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.indigo, width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade900, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade900, width: 2),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
