import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(100.0),
              child: Center(
                child: Text('Texto creativo!'),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: null, child: const Text('-')),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: null, child: const Text('+')),
                )
              ],)
          ],
        ),
      ),
    );
  }
}
