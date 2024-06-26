import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schichtbuch_shift/components/button.dart';
import 'package:schichtbuch_shift/global/index.dart';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable

class MachineStatus extends StatefulWidget {
  final BehaviorSubject<bool> valueChanges = BehaviorSubject<bool>();

  final bool onStatus;
  final String machine;

  MachineStatus({required this.machine, required this.onStatus});

  @override
  State<MachineStatus> createState() => _MachineStatusState();
}

class _MachineStatusState extends State<MachineStatus> {
  String status = 'yellow';

  void initState() {
    super.initState();
    getDevice();
  }

  void getDevice() {
    var response = http.get(
      Uri.parse('http://$ipAdress/api/status/${key}/${widget.machine}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    response.then((value) {
      var data = jsonDecode(value.body);
      setState(() {
        if (data['status'] == "ok") {
          status = "success";
        } else {
          status = "yellow";
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Button(type: status, text: widget.machine)))
    ]);
  }
}
