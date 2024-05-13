import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit_example/generated/l10n.dart';
import 'package:flutter_nfc_kit_example/global/index.dart';
import 'dart:async';
import 'package:flutter_nfc_kit_example/pages/mode/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_manager/nfc_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  bool loading = false;
  bool _notValid = false;

  String _readFromNfcTag = '';

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _tokenIdController = TextEditingController();

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
    // NfcManager.instance.startSession(
    //   onDiscovered: (NfcTag tag) async {
    //     var ndef = Ndef.from(tag);
    //     if (ndef != null && ndef.cachedMessage != null) {
    //       String tempRecord = '';
    //       for (var record in ndef.cachedMessage!.records) {
    //         tempRecord =
    //             '$tempRecord ${String.fromCharCodes(record.payload.sublist(record.payload[0] + 1))}';
    //       }
    //       setState(() {
    //         _readFromNfcTag = tempRecord.replaceAll(
    //           new RegExp(r'\s+\b|\b\s'),
    //           '',
    //         );
    //         _tokenIdController.text = _readFromNfcTag;
    //       });
    //       setState(() {
    //         loading = true;
    //       });
    //       loginRequest(_readFromNfcTag);
    //     }
    //   },
    // );
  }

  @override
  void dispose() {
    // NfcManager.instance.stopSession();
    _tokenIdController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = connectivityResult[
          0]; // Extract the first ConnectivityResult from the list
    });
  }

  loginRequest(token) async {
    var response = await http.put(Uri.parse('http://${ipAdress}/api/token/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'token': token}));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['token'] != 'Invalid') {
        print(data);
        setState(() {
          user = data['name'];
          key = "${data['token']}";
          loading = false;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ChooseMode()),
              (route) => false);
        });
        print("token: $token");
        print("dataToke: ${data['token']}");
      } else {
        setState(() {
          loading = false;
          _notValid = true;
        });
        Timer(const Duration(seconds: 2), () {
          setState(() {
            _notValid = false;
          });
        });
      }
    } else {
      setState(() {
        loading = false;
        _notValid = true;
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          _notValid = false;
        });
      });
      print('Failed to update');
    }
  }

  login() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    loginRequest(_tokenIdController.text);
  }

  @override
  Widget build(BuildContext context) {
    print(key);
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          // backgroundColor: const Color.fromARGB(255, 11, 10, 10),
          appBar: AppBar(
              title: Text(S.of(context).shiftLog,
                  style: TextStyle(
                      color: Color(0Xff336699),
                      fontFamily: 'Lexend',
                      fontSize: 25),
                  textAlign: TextAlign.center),
              actions: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text('${S.of(context).version}: V1.0.0',
                        style: TextStyle(
                            color: Color(0Xff848484),
                            fontFamily: 'Lexend',
                            fontSize: 15)))
              ],
              centerTitle: true,
              flexibleSpace: Container(
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
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
                  child: Container(
                      height: MediaQuery.of(context).size.height - 80,
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: const Image(
                                width: 160,
                                height: 160,
                                image:
                                    AssetImage('assets/images/Terminal.png'))),
                        Expanded(
                            child: Center(
                                child: SizedBox(
                                    width: 450,
                                    height: 320,
                                    child: Container(
                                        decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      30, 5, 119, 190),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 0))
                                            ],
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            )),
                                        width: 100,
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                24, 34, 24, 34),
                                            child: Form(
                                                key: _loginFormKey,
                                                child: Column(children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Text(
                                                            S.of(context).login,
                                                            style: GoogleFonts.lexend(
                                                                textStyle: const TextStyle(
                                                                    color: Color(
                                                                        0xff336699),
                                                                    fontSize:
                                                                        32,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600))),
                                                        const Positioned(
                                                            right: 0,
                                                            child: Image(
                                                                width: 40,
                                                                height: 40,
                                                                image: AssetImage(
                                                                    'assets/images/nfc.png')))
                                                      ],
                                                    ),
                                                  ),
                                                  _notValid
                                                      ? Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .red[100],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              border: Border.all(
                                                                  color: Colors
                                                                          .red[
                                                                      400]!,
                                                                  width: 1)),
                                                          child: Row(children: [
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            2),
                                                                child: Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                            Text(
                                                                S
                                                                    .of(context)
                                                                    .tokenNotValid,
                                                                style: GoogleFonts.lexend(
                                                                    textStyle: const TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600)))
                                                          ]))
                                                      : SizedBox(height: 30),
                                                  const SizedBox(height: 20),
                                                  Container(
                                                      height: 80,
                                                      child: TextFormField(
                                                        controller:
                                                            _tokenIdController,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty)
                                                            return S
                                                                .of(context)
                                                                .requiredField;
                                                          return null;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        style: GoogleFonts.lexend(
                                                            textStyle:
                                                                const TextStyle(
                                                                    color: Color(
                                                                        0xff848484),
                                                                    fontSize:
                                                                        14)),
                                                        decoration: InputDecoration(
                                                            errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        6),
                                                                borderSide: const BorderSide(
                                                                    color: Color(
                                                                        0xff848484),
                                                                    width: .5)),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        6),
                                                                borderSide: const BorderSide(
                                                                    color: Color(
                                                                        0xff336699),
                                                                    width: .5)),
                                                            focusedErrorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        6),
                                                                borderSide: const BorderSide(
                                                                    color: Color(0xff336699),
                                                                    width: .5)),
                                                            contentPadding: const EdgeInsets.all(14),
                                                            labelText: S.of(context).tokenId,
                                                            labelStyle: GoogleFonts.lexend(textStyle: const TextStyle(color: Color(0xff848484), fontSize: 14)),
                                                            prefixIcon: const Align(widthFactor: 1.0, heightFactor: 1.0, child: Image(image: AssetImage('assets/images/idCard.png'))),
                                                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xff848484), width: .5))),
                                                      )),
                                                  SizedBox(
                                                      height: 50,
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      child: TextButton(
                                                          style: TextButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xff336699),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          6))),
                                                          child: loading
                                                              ? const CircularProgressIndicator(
                                                                  valueColor:
                                                                      AlwaysStoppedAnimation<Color>(Colors
                                                                          .white))
                                                              : Text(S.of(context).login,
                                                                  style: GoogleFonts.lexend(textStyle: const TextStyle(color: Colors.white, fontSize: 14))),
                                                          onPressed: login))
                                                  // onPressed: () {
                                                  //   Navigator.push(
                                                  //       context,
                                                  //       MaterialPageRoute(
                                                  //           builder:
                                                  //               (context) =>
                                                  //                   HomePage()));
                                                  // }))
                                                ])))))))
                      ])))),
    );
  }
}
