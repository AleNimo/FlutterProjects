import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primer_parcial/core/language/language.dart';
import 'package:primer_parcial/domain/models/dialogs.dart';
import 'package:primer_parcial/presentation/providers/language_provider.dart';
import 'package:primer_parcial/presentation/providers/theme_provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Configuration extends ConsumerWidget {
  const Configuration({super.key});

  @override
  Widget build(BuildContext context, ref) {
    bool isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    Color selectedColor = ref.watch(themeNotifierProvider).selectedColor;

    final selectedLanguage = ref.watch(languageProvider);

    final textStyle = Theme.of(context).textTheme;

    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Icon(Icons.settings),
              ),
              Text(appLocalizations.settings),
            ],
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(appLocalizations.theme, style: textStyle.titleLarge),
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
            const Divider(),
            SwitchListTile(
              title: Row(
                children: [
                  const Icon(Icons.dark_mode),
                  const SizedBox(width: 15),
                  Text(appLocalizations.darkMode, style: textStyle.titleLarge),
                ],
              ),
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeNotifierProvider.notifier).toggleDarkMode();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.translate),
              title:
                  Text(appLocalizations.language, style: textStyle.titleLarge),
              trailing: PopupMenuButton<Language>(
                onSelected: (language) =>
                    ref.read(languageRepositoryProvider).setLanguage(language),
                itemBuilder: (context) => [
                  for (var language in Language.values)
                    PopupMenuItem(
                      value: language,
                      child: Text(language.name),
                    ),
                ],
                child: Text(selectedLanguage.name, style: textStyle.titleSmall),
              ),
            ),
          ],
        ));
  }
}
