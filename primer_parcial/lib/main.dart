import 'package:flutter/material.dart';
import 'package:primer_parcial/core/database/database.dart';
import 'package:primer_parcial/core/router/app_router.dart';

late AppDatabase database;

void main() async {
  // Me aseguro de tener inicializado binding antes de crear base de datos
  WidgetsFlutterBinding.ensureInitialized();

  // Creo la base de datos, y si es la primera vez la lleno con ejemplos del repositorio falso
  database = await AppDatabase.create('app_database.db');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
