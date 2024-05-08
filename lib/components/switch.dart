// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:google_fonts/google_fonts.dart';

class SwitchWithText extends StatelessWidget {
  VoidCallback? onChange;
  bool value;
  String? label;

  SwitchWithText(
      {this.onChange, required this.value, this.label = "", Key? key})
      : super(key: key);

  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label!,
          style: GoogleFonts.lexend(
              textStyle: const TextStyle(
                  color: Color(0xff336699),
                  fontSize: 22,
                  fontWeight: FontWeight.w500)),
        ),
        label == ""
            ? const SizedBox()
            : const SizedBox(
                width: 20,
              ),
        GestureDetector(
          onTap: onChange,
          child: Container(
            width: 55,
            height: 25,
            decoration: BoxDecoration(
              color: value ? Color(0xff336699) : Color(0xff848484),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: const Color(0xff848484),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).yes,
                          style: TextStyle(
                              color: value ? Colors.white : Colors.transparent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(S.of(context).no,
                            style: TextStyle(
                                color:
                                    value ? Colors.transparent : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment:
                      value ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 21.5,
                      height: 21.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
