import 'package:flutter/material.dart';
import 'APIs/StudentApi.dart';
import 'APIs/LocationApi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // Theme configuration...
          ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Country and State Dropdowns'),
        ),
        body:
            CountryStateDropdowns(), // Use the CountryStateDropdowns widget here
      ),
    );
  }
}
