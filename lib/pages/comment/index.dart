import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit_example/components/button.dart';
import 'package:flutter_nfc_kit_example/components/input.dart';
import 'package:flutter_nfc_kit_example/components/switch.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';

class CommentPage extends StatefulWidget {
  @override
  State<CommentPage> createState() => _CommentState();
}

class _CommentState extends State<CommentPage> {
  bool prepearingShift = false;

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text(S.of(context).modifyExistingEntries,
                    style: TextStyle(
                        color: Color(0xff336699),
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
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
                            style: TextStyle(
                                color: Color(0xff336699), fontSize: 20))
                      ])),
                  SizedBox(width: 40.0),
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
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
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.0),
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
                        Text("${S.of(context).date} / ${S.of(context).time}",
                            style: TextStyle(
                                color: Color(0xff336699),
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 50.0),
                        Text(DateTime.now().toString().substring(0, 10),
                            style: TextStyle(
                                color: Color(0xff848484),
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                        // current time
                        SizedBox(width: 10.0),
                        Text("|",
                            style: TextStyle(
                                color: Color(0xff848484),
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                        SizedBox(width: 10.0),
                        Text(DateTime.now().toString().substring(11, 16),
                            style: TextStyle(
                                color: Color(0xff848484),
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Input(
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
                                  // Navigator.pop(context);
                                })),
                        SizedBox(width: 20.0),
                        Expanded(
                            child: Button(
                                text: S.of(context).save,
                                onPressed: () {
                                  // Navigator.pop(context);
                                }))
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
