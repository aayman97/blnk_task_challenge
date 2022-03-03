import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:edge_detection/edge_detection.dart';

void main() {
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
  File fileImage = File("");
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          Spacer(),
          if (fileImage.path.length > 0)
            Image.file(
              fileImage,
              width: width * 0.6,
              height: height * 0.2,
              fit: BoxFit.cover,
            ),
          Center(
              child: GestureDetector(
            onTap: () async {
              final imagePath = await EdgeDetection.detectEdge;

              if (imagePath == null) {
                print("no path");
              } else {
                setState(() {
                  fileImage = File(imagePath);
                });
              }
            },
            child: Container(
              width: width * 0.3,
              height: height * 0.1,
              color: Colors.black,
            ),
          )),
          Spacer()
        ],
      ),
    );
  }
}
