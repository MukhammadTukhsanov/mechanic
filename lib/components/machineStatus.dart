import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/components/button.dart';
import 'package:flutter_nfc_kit_example/global/index.dart';

import 'package:http/http.dart' as http;

// ignore: must_be_immutable

class MachineStatus extends StatefulWidget {
  late bool onStatus = true;
  late String machine;

  MachineStatus({required this.machine, required this.onStatus});

  @override
  State<MachineStatus> createState() => _MachineStatusState();
}

class _MachineStatusState extends State<MachineStatus> {
  String status = 'yellow';

  void initState() {
    print("object");
    getDevice();
  }

  void getDevice() {
    var response = http.get(
      Uri.parse(
          'http://${ipAdress}/api/machines/${widget.machine}/status'), // 80735001
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    response.then((value) {
      var data = jsonDecode(value.body);
      setState(() {
        status = data['machineStatus'] == "completed" ? "success" : "yellow";
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onStatus) {
      getDevice();
      print("object readed");
      setState(() => widget.onStatus = false);
    }
    // getDevice();
    return Row(children: [
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Button(type: status, text: widget.machine)))
    ]);
  }
}
