import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:primer_parcial/core/database/database.dart';
import 'package:primer_parcial/core/router/app_router.dart';
import 'package:primer_parcial/presentation/providers/theme_provider.dart';

late AppDatabase localDatabase;

late final Directory userDocsDirectory;

void main() async {
  // Me aseguro de tener inicializado binding antes de crear base de datos
  WidgetsFlutterBinding.ensureInitialized();

  // Obtengo directorio donde se almacenan imágenes para la aplicación.
  userDocsDirectory = await getApplicationDocumentsDirectory();

  // Creo la base de datos, y si es la primera vez la lleno con ejemplos del repositorio falso
  localDatabase = await AppDatabase.create('app_database.db');

  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: appTheme.getTheme(),
    );
  }
}
