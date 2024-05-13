import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/components/button.dart';
import 'package:flutter_nfc_kit_example/components/input.dart';
import 'package:flutter_nfc_kit_example/components/switch.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:flutter_nfc_kit_example/global/index.dart';
import 'package:flutter_nfc_kit_example/pages/mode/index.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class CommentPage extends StatefulWidget {
  @override
  State<CommentPage> createState() => _CommentState();
}

class _CommentState extends State<CommentPage> {
  bool error = false;

  final _commentPageKey = GlobalKey<FormState>();

  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      setState(() {
        if (results.isNotEmpty) {
          _connectivityResult = results.last;
        } else {
          _connectivityResult = ConnectivityResult.none;
        }
      });
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult[
          0]; // Extract the first ConnectivityResult from the list
    });
  }

  void _timer() {
    var response = http.get(
      Uri.parse('http://$ipAdress/api/machines/$key/stop'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    response.then((value) {
      var data = jsonDecode(value.body);
    }).catchError((error) {
      print(error);
    });
  }

  onSave() async {
    if (!_commentPageKey.currentState!.validate()) {
      setState(() {
        error = true;
      });
      return;
    }
    await http
        .post(Uri.parse('http://$ipAdress/api/comments/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "comment": "${commentController.text}",
              "preparation_shift": prepearingShift ? "ok" : "no",
              "token": "${key}"
            }))
        .then((value) {
      if (value.statusCode == 200) {
        showSnackBarFun(context, S.of(context).entryAdded, "success");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChooseMode()));
      }
      print(value.body);
    }).catchError((error) {
      showSnackBarFun(context, S.of(context).errorSaving, "error");
      print(error);
    });
  }

  bool prepearingShift = false;

  showSnackBarFun(context, String text, String status) {
    SnackBar snackBar = SnackBar(
      content: Text(text, style: TextStyle(fontSize: 20, color: Colors.white)),
      backgroundColor: status == "success" ? Colors.green : Colors.red,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text(S.of(context).modifyExistingEntries,
                    style: GoogleFonts.lexend(
                        textStyle: TextStyle(
                            color: Color(0xff336699),
                            fontSize: 25,
                            fontWeight: FontWeight.bold))),
                leading: Builder(builder: (BuildContext context) {
                  return IconButton(
                      icon:
                          Icon(Icons.menu, color: Color(0xff336699), size: 30),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip);
                }),
                actions: [
                  Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xff848484), width: 0.5),
                          borderRadius: BorderRadius.circular(5.0)),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                      child: Row(children: [
                        Icon(Icons.person_outline,
                            color: Color(0xff336699), size: 30),
                        SizedBox(width: 10.0),
                        Text(S.of(context).user,
                            style: GoogleFonts.lexend(
                                textStyle: TextStyle(
                                    color: Color(0xff336699), fontSize: 20)))
                      ])),
                  SizedBox(width: 40.0),
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChooseMode()));
                          },
                          icon: Icon(Icons.logout,
                              color: Colors.red, size: 30.0)))
                ],
                centerTitle: true,
                flexibleSpace: Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(30, 5, 119, 190),
                      spreadRadius: 0,
                      blurRadius: 3,
                      offset: Offset(0, 3))
                ]))),
            body: _connectivityResult == ConnectivityResult.none
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 100, color: Colors.red[200]),
                      SizedBox(height: 20),
                      Text(S.of(context).noInternetConnection,
                          style: GoogleFonts.lexend(
                              textStyle: const TextStyle(
                                  color: Color(0xff848484),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)))
                    ],
                  ))
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Form(
                        key: _commentPageKey,
                        child: Column(
                          children: [
                            SwitchWithText(
                                value: prepearingShift,
                                onChange: () {
                                  setState(() {
                                    prepearingShift = !prepearingShift;
                                  });
                                },
                                label: S.of(context).preparationOfShift),
                            SizedBox(height: 40.0),
                            Row(
                              children: [
                                Text(
                                    "${S.of(context).date} / ${S.of(context).time}",
                                    style: GoogleFonts.lexend(
                                        textStyle: TextStyle(
                                            color: Color(0xff336699),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                                SizedBox(width: 50.0),
                                Text(DateTime.now().toString().substring(0, 10),
                                    style: GoogleFonts.lexend(
                                        textStyle: TextStyle(
                                            color: Color(0xff848484),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400))),
                                // current time
                                SizedBox(width: 10.0),
                                Text("|",
                                    style: TextStyle(
                                        color: Color(0xff848484),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(width: 10.0),
                                Text(
                                    DateTime.now().toString().substring(11, 16),
                                    style: GoogleFonts.lexend(
                                        textStyle: TextStyle(
                                            color: Color(0xff848484),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                            SizedBox(height: 40.0),
                            Input(
                                validator: true,
                                controller: commentController,
                                label: S.of(context).comment,
                                maxLines: 5),
                            SizedBox(height: 40.0),
                            Row(
                              children: [
                                Expanded(
                                    child: Button(
                                        text: S.of(context).cancel,
                                        type: "outline",
                                        onPressed: () {
                                          _timer();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChooseMode()));
                                        })),
                                SizedBox(width: 20.0),
                                Expanded(
                                    child: Button(
                                        text: S.of(context).save,
                                        onPressed: onSave))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )));
  }
}
