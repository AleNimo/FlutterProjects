import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:primer_parcial/core/database/database.dart';
import 'package:primer_parcial/core/router/app_router.dart';
import 'package:primer_parcial/presentation/providers/language_provider.dart';
import 'package:primer_parcial/presentation/providers/theme_provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late AppDatabase localDatabase;

late final Directory userDocsDirectory;

Future<void> main() async {
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
    final selectedLanguage = ref.watch(languageProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: appTheme.getTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(selectedLanguage.code),
    );
  }
}
