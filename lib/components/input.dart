import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  const Input({
    Key? key,
    this.label = '',
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
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label == ''
            ? SizedBox(height: 0)
            : Text(
                label!,
                style: TextStyle(
                  color: Color(0xff336699),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
        label == '' ? SizedBox(height: 0) : SizedBox(height: 10),
        Container(
          color: disabled ? Color.fromARGB(30, 132, 132, 132) : Colors.white,
          child: TextFormField(
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
            inputFormatters: [
              numericOnly == true
                  ? FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  : FilteringTextInputFormatter.singleLineFormatter
            ],
            // keyboardType: keyboardType ?? TextInputType.text,
            // inputFormatters: numericOnly == true
            //     ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            //     : null,
            readOnly: readOnly ?? false,
            maxLines: maxLines,
            textAlignVertical: TextAlignVertical.top,
            enabled: !disabled,
            controller: controller,
            obscureText: isPassword,
            focusNode: focusNode,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 0),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 19, horizontal: 20),
              alignLabelWithHint: true,
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(prefixIcon, color: Color(0xff848484), size: 30),
              labelText: labelText,
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
