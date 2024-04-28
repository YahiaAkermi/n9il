import 'package:flutter/material.dart';
import 'package:untitled/details.dart';
import 'package:untitled/home.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: "/details",
          page: () => const Details(),
        ),
      ],
      home: Home(),
    );
  }
}

