import 'package:flutter/material.dart';
import 'package:flutter_run_record_app/views/my_run_ui.dart';
import 'package:flutter_run_record_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    FlutterRunRecordApp(),
  );
}

//--------------------------------
class FlutterRunRecordApp extends StatefulWidget {
  const FlutterRunRecordApp({super.key});

  @override
  State<FlutterRunRecordApp> createState() => _FlutterRunRecordAppState();
}

class _FlutterRunRecordAppState extends State<FlutterRunRecordApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyRunUI(),
      theme: ThemeData(
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
