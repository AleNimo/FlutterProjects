import 'package:flutter/material.dart';

class Configuration extends StatelessWidget {
  const Configuration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Icon(Icons.settings),
              ),
              Text('Configuración'),
            ],
          ),
        ),
        body: ListView(
          children: const [
            Text('Color', style: TextStyle(fontSize: 100)),
            Text('Tema', style: TextStyle(fontSize: 100)),
            Text('Idioma', style: TextStyle(fontSize: 100)),
          ],
        ));
  }
}
