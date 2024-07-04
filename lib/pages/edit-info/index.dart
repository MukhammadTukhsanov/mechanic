import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schichtbuch_shift/generated/l10n.dart';
import 'package:schichtbuch_shift/global/index.dart';

import 'package:http/http.dart' as http;
import 'package:schichtbuch_shift/pages/edit-info/machineItem.dart';

class EditInfo extends StatefulWidget {
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State {
  List editedDevices = [];
  void initState() {
    super.initState();
    getDevice();
  }

  void getDevice() {
    var response = http.get(
      Uri.parse('http://$ipAdress/api/machines/$key'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    response.then((value) {
      var data = jsonDecode(value.body);
      setState(() {
        editedDevices = data;
      });
    }).catchError((error) {
      print("error $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("Einträge bearbeiten",
                style: TextStyle(
                    color: Color(0xff336699),
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            leading: Builder(builder: (BuildContext context) {
              // Navigate back button
              return IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xff336699)),
                  onPressed: () {
                    Navigator.pop(context);
                  });
            }),
            centerTitle: true,
            flexibleSpace: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(30, 5, 119, 190),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: Offset(0, 3))
            ]))),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
              children: editedDevices.map((e) {
            return new MachineItem(
              id: e['id'].toString(),
              pieceNumber: e['pieceNumber'] ?? 0,
              token: e['token'] ?? '',
              toolMounted: e['toolMounted'] ?? false,
              machineStopped: e['machineStopped'] ?? false,
              machineQrCode: e['machineQrCode'] ?? '',
              createdAt: e['createdAt']?.toString() ?? '',
              shift: e['shift'] ?? '',
              barcodeProductionNo: e['barcodeProductionNo'] ?? 0,
              partName: e['partName'] ?? '',
              partNumber: e['partNumber'] ?? '',
              cavity: e['cavity'] ?? 0,
              cycleTime: e['cycleTime'] ?? '',
              partStatus: e['partStatus'] ?? false,
              note: e['note'] ?? '',
              toolCleaning: e['toolCleaning'] ?? false,
              remainingProductionTime: e['remainingProductionTime'] ?? 0,
              remainingProductionDays: e['remainingProductionDays'] ?? 0,
              operatingHours: e['operatingHours'] ?? '',
            );
          }).toList()),
        )));
  }
}
