import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/components/machineStatus.dart';
import 'package:flutter_nfc_kit_example/global/index.dart';
import 'package:http/http.dart' as http;

class MachineStatusList extends StatefulWidget {
  bool changeStatus;
  MachineStatusList({Key? key, required this.changeStatus}) : super(key: key);
  @override
  State<MachineStatusList> createState() => _MachineStatusListState();
}

class _MachineStatusListState extends State<MachineStatusList> {
  String status = 'yellow';
  List device = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...globalDevices.map((e) {
          return MachineStatus(
            onStatus: widget.changeStatus,
            machine: e,
          );
        }).toList(),
      ],
    );
  }
}
