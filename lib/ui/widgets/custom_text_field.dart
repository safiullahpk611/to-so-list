import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController myController;
  final TextInputType keyBoardType;
  final bool obscureText;
  final VoidCallback? ontap;
  final FormFieldValidator validator;

  final prefixIcon;
  final suffix;
  final FocusNode? focusNode;
  final textInputAction;
  final foucsBorderColor;
  final onChanged;
  final readOnly;
  final textfiledOnTap;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.foucsBorderColor = const Color(0xffD1E6FF),
    this.readOnly = false,
    required this.myController,
    required this.keyBoardType,
    required this.obscureText,
    this.ontap,
    this.focusNode,
    this.suffix,
    this.textInputAction,
    this.textfiledOnTap,
    required this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: textfiledOnTap,
      focusNode: focusNode,
      readOnly: readOnly,
      onChanged: onChanged,
      validator: validator,
      controller: myController,
      keyboardType: keyBoardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      autocorrect: true,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: hintText,
        labelStyle: TextStyle(
          color: Color(0xff3C3C43).withOpacity(0.6),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffix: suffix,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xff3C3C43).withOpacity(0.6),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xffD1D1D6)),
          borderRadius: BorderRadius.circular(14),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xffD1D1D6), width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
                color: foucsBorderColor != null
                    ? foucsBorderColor
                    : Color(0xffD1E6FF),
                width: 2)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
