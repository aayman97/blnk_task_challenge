import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:blnk_task_challenge/api/users_sheets_api.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart' as googleSignIn;
import 'package:blnk_task_challenge/auth/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:edge_detection/edge_detection.dart';
import 'auth/GoogleDrive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await UserSpreadSheetApi.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = FlutterSecureStorage();
  bool loading = false;
  File fileImage = File("");
  List<File> _fileImages = [];
  String _firstName = "";
  String _lastName = "";
  String _address = "";
  String _landline = "";
  String _mobile = "";
  String dropdownValue = 'Cairo, Egypt';

  int? _counter;

  Future<Map<String, dynamic>?> getCounter() async {
    var result = await storage.readAll();
    if (!result.isEmpty) {
      final data = jsonDecode(jsonEncode(result));
      _counter = int.parse(data['counter']);
    } else {
      _counter = 2;
    }

    // await storage.deleteAll();
  }

  @override
  initState() {
    getCounter();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xff232366),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          top: true,
          bottom: true,
          child: Container(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/Consumer_Logo.png",
                    width: width * 0.3,
                    height: width * 0.3,
                  ),
                  FirstNameTextInput(width),
                  LastNameTextInput(width),
                  AddressTextInput(width),
                  Container(
                    width: 300,
                    height: height * 0.05,
                    color: Colors.white,
                    child: Center(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xff232366),
                        ),
                        elevation: 8,
                        underline: SizedBox(),
                        style: const TextStyle(
                            color: Color(0xff232366),
                            fontWeight: FontWeight.bold),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['Lagas, Nigeria', 'Cairo, Egypt']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  color: Color(0xff232366),
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  LandlineTextInput(width),
                  MobileTextInput(width),
                  if (_fileImages.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _fileImages.map((e) {
                        return Stack(
                          children: [
                            Image.file(
                              e,
                              width: width * 0.45,
                              height: height * 0.1,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                top: 3,
                                left: (width * 0.4) - 20,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _fileImages
                                          .removeAt(_fileImages.indexOf(e));
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Color(0xff232366),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ],
                        );
                      }).toList(),
                    ),
                  Center(
                      child: GestureDetector(
                    onTap: () async {
                      if (_fileImages.length < 2) {
                        final imagePath = await EdgeDetection.detectEdge;

                        if (imagePath == null) {
                          print("no path");
                        } else {
                          File temp = File(imagePath);
                          setState(() {
                            // fileImage = File(imagePath);
                            _fileImages.add(temp);
                          });
                        }
                      }
                    },
                    child: Container(
                      width: width * 0.8,
                      height: height * 0.05,
                      margin: EdgeInsets.only(
                        top: height * 0.02,
                      ),
                      decoration: BoxDecoration(
                          color: _fileImages.length == 2
                              ? Colors.grey
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: _fileImages.length == 1
                            ? Text(
                                "Upload the second side of the National ID",
                                style: TextStyle(
                                    color: Color(0xff232366), fontSize: 12),
                              )
                            : _fileImages.length == 2
                                ? Text(
                                    "Uploaded Both front and back of the National ID",
                                    style: TextStyle(
                                        color: Color(0xff232366), fontSize: 12),
                                  )
                                : Text(
                                    "Upload the first side of the National ID",
                                    style: TextStyle(
                                        color: Color(0xff232366), fontSize: 12),
                                  ),
                      ),
                    ),
                  )),
                  GestureDetector(
                    onTap: () async {
                      if (_firstName.length > 0 &&
                          _lastName.length > 0 &&
                          _address.length > 0 &&
                          _landline.length > 0 &&
                          _mobile.length > 0 &&
                          dropdownValue.length > 0) {
                        if (!loading) {
                          setState(() {
                            loading = true;
                          });
                          UserSpreadSheetApi.insert(
                                  _counter!,
                                  _firstName,
                                  _lastName,
                                  _address,
                                  _landline,
                                  "+2" + _mobile,
                                  dropdownValue)
                              .then((value) async {
                            setState(() {
                              _counter = _counter! + 1;
                              loading = false;
                            });
                            await storage.write(
                                key: "counter", value: _counter.toString());
                          });
                        }
                      }
                    },
                    child: Container(
                        width: width * 0.4,
                        height: height * 0.05,
                        margin: EdgeInsets.only(
                          top: height * 0.02,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: loading
                              ? SizedBox(
                                  height: width * 0.05,
                                  width: width * 0.05,
                                  child: CircularProgressIndicator())
                              : Text("Confirm Data"),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container FirstNameTextInput(double width) {
    return Container(
      width: width * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelStyle: TextStyle(color: Colors.white),
            focusColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.2), width: 1.0),
            ),
            hintText: 'First name',
          ),
          onChanged: (value) {
            setState(() {
              _firstName = value;
            });
          },
        ),
      ),
    );
  }

  Container LastNameTextInput(double width) {
    return Container(
      width: width * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelStyle: TextStyle(color: Colors.white),
            focusColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.2), width: 1.0),
            ),
            hintText: 'Last name',
          ),
          onChanged: (value) {
            setState(() {
              _lastName = value;
            });
          },
        ),
      ),
    );
  }

  Container AddressTextInput(double width) {
    return Container(
      width: width * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelStyle: TextStyle(color: Colors.white),
            focusColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.2), width: 1.0),
            ),
            hintText: 'Address',
          ),
          onChanged: (value) {
            setState(() {
              _address = value;
            });
          },
        ),
      ),
    );
  }

  Container LandlineTextInput(double width) {
    return Container(
      width: width * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          keyboardType: TextInputType.number,
          maxLength: 7,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelStyle: TextStyle(color: Colors.white),
            focusColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.2), width: 1.0),
            ),
            hintText: 'Landline',
          ),
          onChanged: (value) {
            setState(() {
              _landline = value;
            });
          },
        ),
      ),
    );
  }

  Container MobileTextInput(double width) {
    return Container(
      width: width * 0.9,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          keyboardType: TextInputType.number,
          maxLength: 11,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelStyle: TextStyle(color: Colors.white),
            focusColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.2), width: 1.0),
            ),
            hintText: 'Mobile',
          ),
          onChanged: (value) {
            setState(() {
              _mobile = value;
            });
          },
        ),
      ),
    );
  }
}
