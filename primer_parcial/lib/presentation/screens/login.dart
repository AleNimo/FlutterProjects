import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:primer_parcial/domain/models/user.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.repository});

  final Repository repository;

  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    checkActiveUser();
  }

  void checkActiveUser() async {
    final int? activeUserId = await widget.asyncPrefs.getInt('activeUserId');

    if (activeUserId != null) {
      if (mounted) context.go('/trees/$activeUserId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
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
                  asyncPrefs: widget.asyncPrefs,
                );
              } else {
                return Center(child: Text(snapshot.error.toString()));
              }
            },
          ),
        ));
  }
}

class LoginWidgets extends StatefulWidget {
  const LoginWidgets(
      {super.key, required this.users, required this.asyncPrefs});

  final List<User> users;
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
    return Center(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
                child: TextFormField(
                  key: userKey,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (String? inputUser) {
                    if (inputUser == null || inputUser.isEmpty) {
                      return 'Ingresar usuario';
                    } else {
                      matchedUser = widget.users
                          .firstWhereOrNull((user) => user.name == inputUser);
                      if (matchedUser == null) {
                        return 'Usuario inválido';
                      }
                    }
                    return null;
                  },
                  onSaved: (inputUser) => userName = inputUser!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
                child: TextFormField(
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  validator: (String? inputPassword) {
                    if (inputPassword == null || inputPassword.isEmpty) {
                      return 'Ingresar contraseña';
                    } else {
                      final validUser = userKey.currentState!.validate();

                      if (validUser) {
                        if (matchedUser!.password != inputPassword) {
                          return 'Contraseña incorrecta';
                        }
                      }
                    }
                    return null;
                  },
                  onSaved: (inputPassword) => password = inputPassword!,
                ),
              ),
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
                child: const Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
