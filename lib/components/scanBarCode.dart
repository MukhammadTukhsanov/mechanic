import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanBarCode extends StatefulWidget {
  final String? labelText;
  final String? code;
  final Function(String)? setCode;

  ScanBarCode({Key? key, required this.labelText, this.code, this.setCode})
      : super(key: key);
  @override
  _ScanBarCodeState createState() => _ScanBarCodeState();
}

class _ScanBarCodeState extends State<ScanBarCode> {
  Future<void> scanCode() async {
    String code;
    try {
      code = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
    } on PlatformException {
      code = 'Failed to get platform version.';
    }
    widget.setCode!(code);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: scanCode,
      child: Container(
        height: 55,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(Icons.qr_code, color: const Color(0xff848484), size: 30),
              const SizedBox(width: 10.0),
              Text("${widget.code == "" ? widget.labelText : widget.code}",
                  style: GoogleFonts.lexend(
                      textStyle: const TextStyle(
                          color: Color(0xff848484),
                          fontSize: 20,
                          fontWeight: FontWeight.w400))),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff848484),
            width: 0.7,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
