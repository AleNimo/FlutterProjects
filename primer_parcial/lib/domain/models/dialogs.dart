import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:primer_parcial/domain/models/snackbar.dart';
import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/user.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';

bool globalFlagRefreshList = false;

void deleteDialog(BuildContext context, Repository repository, Tree tree) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('¿Seguro que desea eliminar el árbol?'),
            content: const Text('Esta acción no puede ser deshecha.'),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancelar')),
              FilledButton(
                  onPressed: () async {
                    await repository.deleteTree(tree);
                    globalFlagRefreshList = true;
                    if (context.mounted) {
                      showSnackbar(context, 'Árbol eliminado exitosamente');
                      context
                        ..pop()
                        ..pop();
                    }
                  },
                  child: const Text('Eliminar')),
            ],
          ));
}

// tree es el arbol a editar, si tree == null es porque se está creando un árbol
void treeDialog(BuildContext context, String title, Repository repository,
    Tree? tree, Function refreshFunction) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = '';
  String scientificName = '';
  String family = '';
  int quantityBsAs = 0;
  String? imageURL;

  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: (tree != null) ? tree.name : '',
                        decoration: const InputDecoration(
                          labelText: 'Nombre informal',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Nombre vacío';
                          }
                          return null;
                        },
                        onSaved: (value) => name = value!,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: (tree != null) ? tree.scientificName : '',
                        decoration: const InputDecoration(
                          labelText: 'Nombre científico',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Nombre científico vacío';
                          }
                          return null;
                        },
                        onSaved: (value) => scientificName = value!,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: (tree != null) ? tree.family : '',
                        decoration: const InputDecoration(
                          labelText: 'Familia',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Familia vacía';
                          }
                          return null;
                        },
                        onSaved: (value) => family = value!,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue:
                            (tree != null) ? tree.quantityBsAs.toString() : '',
                        decoration: const InputDecoration(
                          labelText: 'Cantidad en CABA',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Cantidad vacía';
                          } else if (int.tryParse(value) == null) {
                            return 'Debe ser un número';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          quantityBsAs = int.tryParse(value ?? '') ?? 0;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: (tree != null) ? tree.imageURL : '',
                        decoration: const InputDecoration(
                          labelText: 'URL de imagen',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => imageURL = value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancelar')),
              FilledButton(
                  onPressed: () async {
                    final isValid = formKey.currentState!.validate();

                    if (isValid) {
                      formKey.currentState!.save();

                      if (tree == null) {
                        await repository.insertTree(
                          Tree(
                            name: name,
                            scientificName: scientificName,
                            family: family,
                            quantityBsAs: quantityBsAs,
                            imageURL: imageURL,
                          ),
                        );
                        if (context.mounted) {
                          showSnackbar(context, 'Árbol agregado exitosamente');
                        }
                      } else {
                        await repository.updateTree(
                          Tree(
                            id: tree.id,
                            name: name,
                            scientificName: scientificName,
                            family: family,
                            quantityBsAs: quantityBsAs,
                            imageURL: imageURL,
                          ),
                        );
                        globalFlagRefreshList = true;
                        if (context.mounted) {
                          showSnackbar(context, 'Árbol editado exitosamente');
                        }
                      }
                      refreshFunction();
                      if (context.mounted) context.pop();
                    }
                  },
                  child: const Text('Aceptar')),
            ],
          ));
}

// user es el usuario a editar, si user == null es porque se está creando un usuario
void userDialog(BuildContext context, String title, Repository repository,
    User? user, Function refreshFunction) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String inputName = '';
  String inputEmail = '';
  String inputPassword = '';
  int? inputAge = 0;
  Gender selectedGender;

  if (user != null) {
    selectedGender = user.gender;
  } else {
    selectedGender = Gender.Otro;
  }

  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: StatefulBuilder(
              builder: (context, setState) => SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: (user != null) ? user.name : '',
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Nombre vacío';
                            }
                            return null;
                          },
                          onSaved: (value) => inputName = value!,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: (user != null) ? user.email : '',
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Email vacío';
                            }
                            return null;
                          },
                          onSaved: (value) => inputEmail = value!,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: (user != null) ? user.password : '',
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Contraseña vacía';
                            }
                            return null;
                          },
                          onSaved: (value) => inputPassword = value!,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue:
                              (user != null) ? user.age.toString() : '',
                          decoration: const InputDecoration(
                            labelText: 'Edad',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if (value != null) {
                              if (int.tryParse(value) == null) {
                                return 'Debe ser un número';
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            inputAge = int.tryParse(value ?? '');
                          },
                        ),
                        const SizedBox(height: 10),
                        ExpansionTile(
                          title: const Text('Género'),
                          subtitle: Text(selectedGender.name),
                          children: [
                            RadioListTile(
                              value: Gender.Masculino,
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value as Gender;
                                });
                              },
                              title: const Text('Masculino'),
                            ),
                            RadioListTile(
                              value: Gender.Femenino,
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value as Gender;
                                });
                              },
                              title: const Text('Femenino'),
                            ),
                            RadioListTile(
                              value: Gender.Otro,
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value as Gender;
                                });
                              },
                              title: const Text('Otro'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancelar')),
              FilledButton(
                  onPressed: () async {
                    final isValid = formKey.currentState!.validate();

                    if (isValid) {
                      formKey.currentState!.save();

                      if (user == null) {
                        await repository.insertUser(
                          User(
                            name: inputName,
                            email: inputEmail,
                            password: inputPassword,
                            age: inputAge,
                            gender: selectedGender,
                          ),
                        );
                        if (context.mounted) {
                          showSnackbar(
                              context, 'Usuario agregado exitosamente');
                        }
                      } else {
                        await repository.updateUser(
                          User(
                            id: user.id,
                            name: inputName,
                            email: inputEmail,
                            password: inputPassword,
                            age: inputAge,
                            gender: selectedGender,
                          ),
                        );
                        globalFlagRefreshList = true;
                        if (context.mounted) {
                          showSnackbar(context, 'Usuario editado exitosamente');
                        }
                      }
                      await refreshFunction();
                      if (context.mounted) context.pop();
                    }
                  },
                  child: const Text('Aceptar')),
            ],
          ));
}
