import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:primer_parcial/domain/user.dart';
import 'package:primer_parcial/data/users_repository.dart';

// import 'package:collection/collection.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: const LoginWidgets(),
        ));
  }
}

class LoginWidgets extends StatefulWidget {
  const LoginWidgets({super.key});

  @override
  State<LoginWidgets> createState() => _LoginWidgetsState();
}

class _LoginWidgetsState extends State<LoginWidgets> {
  void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackbar = SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(text),
      // action: SnackBarAction(
      //   label: 'Ok',
      //   onPressed: () {},
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  bool _isObscure = true;

  //El 'final' no permite que cambie la referencia a esta variable (constante en tiempo de ejecución)
  final TextEditingController _inputName = TextEditingController();
  //Lo defino en una variable para poder acceder al texto ingresado
  final TextEditingController _inputPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
          child: TextField(
              decoration: InputDecoration(
                hintText: 'Usuario',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              controller: _inputName),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 8, 50, 8),
          child: TextField(
              obscureText: _isObscure,
              decoration: InputDecoration(
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      })),
              controller: _inputPassword),
        ),
        OutlinedButton(
            onPressed: () {
              if (_inputName.text == '') {
                showSnackbar(context, 'Ingresar usuario');
              } else if (_inputPassword.text == '') {
                showSnackbar(context, 'Ingresar contraseña');
              } else {
                //Sin usar firstWhereOrNull (Uso manejo de excepciones):
                try {
                  User userMatched =
                      users.firstWhere((user) => user.name == _inputName.text);
                  if (userMatched.password == _inputPassword.text) {
                    context.push(
                        '/trees/${_inputName.text}'); //context.push apila pantallas y te deja volver - context.go te manda a la pantalla y no se puede volver
                  } else {
                    showSnackbar(context, 'Contraseña incorrecta');
                  }
                } catch (e) {
                  showSnackbar(context, 'No existe tal usuario');
                }

                //Usando paquete de collection
                // User? userMatched = users.firstWhereOrNull((user) => user.name == _inputName.text); //Asumo que todos los usuarios son distintos (un solo elemento)
                // if(userMatched == null)
                // {
                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No existe tal usuario')));
                // }
                // else if(userMatched.password==_inputPassword.text)
                // {
                //   context.push('/home', extra: _inputName.text); //context.push apila pantallas y te deja volver - context.go te manda a la pantalla y no se puede volver
                // }
                // else
                // {
                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraseña incorrecta')));
                // }
              }
            },
            child: const Text('Login'))
      ],
    ));
  }
}
