import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String? text;
  final Function? onPressed;
  String? type;

  Button({this.text, this.onPressed, this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: type == "success" || type == "yellow" ? 45 : 63,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: type == "outline" ? Color(0xff848484) : Colors.transparent,
            width: 1,
          ),
        ),
        child: TextButton(
          onPressed: onPressed as void Function()?,
          child: Text(
            text!,
            style: TextStyle(
              color: type == "outline" ? Color(0xff848484) : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: type == "outline"
                ? MaterialStateProperty.all<Color>(Colors.white)
                : type == "yellow"
                    ? MaterialStateProperty.all<Color>(Color(0xffe6b400))
                    : type == "success"
                        ? MaterialStateProperty.all<Color>(Color(0xff5CB85C))
                        : MaterialStateProperty.all<Color>(
                            const Color(0xff336699)),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(
                horizontal: 20,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ));
  }
}
