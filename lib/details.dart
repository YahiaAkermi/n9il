import 'package:flutter/material.dart';
import 'package:untitled/note.dart';
import "package:flutter_tts/flutter_tts.dart";
import "package:get/get.dart";

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Note note = Get.arguments!;
  FlutterTts flutterTts = FlutterTts();

  void speak(String text) async {
    await flutterTts.setLanguage('us-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.description!,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Date: ${note.date!}",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                speak(note.description!);
              },
              child: Text("Read Aloud"),
            ),
          ],
        ),
      ),
    );
  }
}
