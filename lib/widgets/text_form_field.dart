// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import '../constants/colors_constants.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final bool readOnly;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function? onChange;
  final TextAlign? textAlign;
  final FormFieldValidator<String>? validator; 

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    required this.controller,
    this.focusNode,
    this.onChange,
    this.textAlign,
    this.validator, required List<TextInputFormatter> inputFormatters,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textAlign: widget.textAlign ?? TextAlign.start,
      onChanged: (value) {
        if (widget.onChange != null) {
          widget.onChange!(value);
        }
      },
      focusNode: widget.focusNode,
      obscureText: widget.obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: TextStyle(
        color: ColorsConstants.primaryBlue,
        fontSize: widget.labelText.isEmpty ? 24 : 18,
        fontFamily: 'Lato',
        fontWeight:
            widget.labelText.isEmpty ? FontWeight.bold : FontWeight.w300,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        hintText: widget.labelText,
        hintStyle: const TextStyle(color: ColorsConstants.text1),
        filled: true,
        fillColor: const Color.fromARGB(255, 210, 210, 210).withOpacity(0.2),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorsConstants.primaryBlue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorsConstants.primaryBlue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: widget.obscureText
            ? GestureDetector(
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: ColorsConstants.primaryBlue,
                ),
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
