import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primer_parcial/domain/models/dialogs.dart';
import 'package:primer_parcial/presentation/providers/theme_provider.dart';

class Configuration extends ConsumerWidget {
  const Configuration({super.key});

  @override
  Widget build(BuildContext context, ref) {
    bool isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    Color selectedColor = ref.watch(themeNotifierProvider).selectedColor;

    final textStyle = Theme.of(context).textTheme;

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
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text('Tema', style: textStyle.headlineMedium),
              trailing: Container(
                  constraints:
                      const BoxConstraints(maxHeight: 20, maxWidth: 20),
                  color: selectedColor),
              onTap: () async {
                Color? newColor = await colorDialog(context, selectedColor);
                if (newColor != null) {
                  ref
                      .read(themeNotifierProvider.notifier)
                      .changeColorTheme(newColor);
                }
              },
            ),
            SwitchListTile(
              title: Row(
                children: [
                  const Icon(Icons.brightness_4),
                  const SizedBox(width: 15),
                  Text('Modo oscuro', style: textStyle.headlineMedium),
                ],
              ),
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeNotifierProvider.notifier).toggleDarkMode();
              },
            ),
            const Text('Idioma', style: TextStyle(fontSize: 100)),
          ],
        ));
  }
}
