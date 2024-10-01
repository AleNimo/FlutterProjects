import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:primer_parcial/core/language/language.dart';
import 'package:primer_parcial/domain/models/dialogs.dart';

import 'package:primer_parcial/domain/models/user.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';
import 'package:primer_parcial/presentation/providers/language_provider.dart';
import 'package:primer_parcial/presentation/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({super.key, required this.repository});

  final Repository repository;

  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
    readSavedParameters();
  }

  void readSavedParameters() async {
    final String? languageCode =
        await widget.asyncPrefs.getString('language_code');
    final int? colorInt = await widget.asyncPrefs.getInt('theme_color');
    final bool? isDarkMode = await widget.asyncPrefs.getBool('dark_mode');
    final int? activeUserId = await widget.asyncPrefs.getInt('activeUserId');

    if (languageCode != null) {
      for (var language in Language.values) {
        if (languageCode == language.code) {
          ref.read(languageProvider.notifier).update((state) => language);
        }
      }
    }

    if (colorInt != null) {
      Color color = Color(colorInt);
      ref.read(themeNotifierProvider.notifier).setColorTheme(color);
    }

    if (isDarkMode != null) {
      ref.read(themeNotifierProvider.notifier).setDarkMode(isDarkMode);
    }

    if (activeUserId != null) {
      User? activeUser = await widget.repository.getUserById(activeUserId);
      if (activeUser != null) {
        if (mounted) context.go('/trees/$activeUserId');
      } else {
        await widget.asyncPrefs.remove('activeUserId');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.login),
      ),
      body: FutureBuilder(
        future: widget.repository.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return LoginWidgets(
              users: snapshot.data!,
              repository: widget.repository,
              asyncPrefs: widget.asyncPrefs,
            );
          } else {
            return Center(child: Text(snapshot.error.toString()));
          }
        },
      ),
    );
  }
}

class LoginWidgets extends StatefulWidget {
  const LoginWidgets(
      {super.key,
      required this.users,
      required this.repository,
      required this.asyncPrefs});

  final List<User> users;
  final Repository repository;
  final SharedPreferencesAsync asyncPrefs;

  @override
  State<LoginWidgets> createState() => _LoginWidgetsState();
}

class _LoginWidgetsState extends State<LoginWidgets> {
  bool _isObscure = true;

  String? userName;
  String? password;
  User? matchedUser;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> userKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        Image.asset(
          'assets/logo.png',
          height: 200,
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  key: userKey,
                  decoration: InputDecoration(
                    labelText: appLocalizations.user,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (String? inputUser) {
                    if (inputUser == null || inputUser.isEmpty) {
                      return appLocalizations.enterUser;
                    } else {
                      matchedUser = widget.users
                          .firstWhereOrNull((user) => user.name == inputUser);
                      if (matchedUser == null) {
                        return appLocalizations.invalidUser;
                      }
                    }
                    return null;
                  },
                  onSaved: (inputUser) => userName = inputUser!,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: appLocalizations.password,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                  ),
                  validator: (String? inputPassword) {
                    if (inputPassword == null || inputPassword.isEmpty) {
                      return appLocalizations.enterPassword;
                    } else {
                      final validUser = userKey.currentState!.validate();

                      if (validUser) {
                        if (matchedUser!.password != inputPassword) {
                          return appLocalizations.invalidPassword;
                        }
                      }
                    }
                    return null;
                  },
                  onSaved: (inputPassword) => password = inputPassword!,
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState!.validate();

                    if (isValid) {
                      formKey.currentState!.save();

                      await widget.asyncPrefs
                          .setInt('activeUserId', matchedUser!.id!);

                      if (context.mounted) {
                        context.go('/trees/${matchedUser!.id!}');
                      }
                    }
                  },
                  child: Text(appLocalizations.login),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(appLocalizations.notHaveAccount),
                    TextButton(
                        onPressed: () {
                          userDialog(context, appLocalizations.register,
                              widget.repository, null, null);
                        },
                        child: Text(appLocalizations.register))
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
