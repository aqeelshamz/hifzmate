import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hifz Mate'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
