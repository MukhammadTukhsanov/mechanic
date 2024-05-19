import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Input extends StatelessWidget {
  const Input(
      {Key? key,
      this.label = '',
      this.fontSize = 15.0,
      required this.controller,
      this.prefixIcon,
      this.labelText,
      this.isPassword = false,
      this.disabled = false,
      this.maxLines = 1,
      this.readOnly = false,
      this.keyboardType,
      this.numericOnly,
      this.showCrusor = true,
      this.onEditingComplete,
      this.focusNode,
      this.validator = true,
      this.onChanged,
      this.inputFormatters,
      this.maxLength})
      : super(key: key);

  final String? label;
  final bool? showCrusor;
  final TextEditingController controller;
  final bool isPassword;
  final IconData? prefixIcon;
  final String? labelText;
  final bool disabled;
  final int? maxLines;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final bool? numericOnly;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final bool? validator;
  final int? maxLength;
  final double? fontSize;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    // print("langugae is ${Localizations.localeOf(context).languageCode}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label == ''
            ? SizedBox(height: 0)
            : Text(label!,
                style: GoogleFonts.lexend(
                  textStyle: TextStyle(
                    color: Color(0xff336699),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                )),
        label == '' ? SizedBox(height: 0) : SizedBox(height: 10),
        Container(
          color: disabled ? Color.fromARGB(30, 132, 132, 132) : Colors.white,
          child: TextFormField(
            style: GoogleFonts.lexend(
              textStyle: TextStyle(
                color: Color(0xff000000),
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
            maxLength: maxLength,
            validator: validator == true
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  }
                : null,
            onEditingComplete: onEditingComplete,
            showCursor: showCrusor,
            keyboardType: keyboardType ?? TextInputType.text,
            inputFormatters: inputFormatters,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            readOnly: readOnly ?? false,
            maxLines: maxLines,
            textAlignVertical: TextAlignVertical.top,
            enabled: !disabled,
            controller: controller,
            obscureText: isPassword,
            onChanged: onChanged,
            focusNode: focusNode,
            decoration: InputDecoration(
              counterText: "",
              counterStyle: TextStyle(fontSize: 0),
              errorStyle: TextStyle(fontSize: 0),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 19, horizontal: 20),
              alignLabelWithHint: true,
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(prefixIcon, color: Color(0xff848484), size: 30),
              labelText: labelText ?? null,
              labelStyle: TextStyle(color: Color(0xff848484), fontSize: 18),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff336699), width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff848484), width: .7),
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
