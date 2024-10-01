import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primer_parcial/domain/models/snackbar.dart';
import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/user.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';
import 'package:primer_parcial/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool globalFlagRefreshList = false;

void deleteTreeDialog(BuildContext context, Repository repository, Tree tree) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('¿Seguro que desea eliminar el árbol?'),
            content: const Text('Esta acción es permanente.'),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancelar')),
              FilledButton(
                  onPressed: () async {
                    await repository.deleteTree(tree);

                    final Directory imagesDir = Directory(
                        '${userDocsDirectory.path}/images/${tree.id}');

                    imagesDir.deleteSync(recursive: true);

                    globalFlagRefreshList = true;
                    if (context.mounted) {
                      showSnackbar(context, 'Árbol eliminado correctamente');
                      context
                        ..pop()
                        ..pop();
                    }
                  },
                  child: const Text('Eliminar')),
            ],
          ));
}

void deleteUserDialog(BuildContext context, Repository repository, User user) {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('¿Seguro que desea eliminar su cuenta?'),
            content: const Text('Esta acción es permanente.'),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Cancelar')),
              FilledButton(
                  onPressed: () async {
                    await repository.deleteUser(user);

                    if (context.mounted) {
                      await asyncPrefs.remove('activeUserId');
                      if (context.mounted) context.go('/login');
                    }
                  },
                  child: const Text('Eliminar')),
            ],
          ));
}

Future<bool> deleteImageDialog(BuildContext context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('¿Seguro que desea eliminar la foto?'),
            content: const Text('Esta acción es permanente.'),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop(false);
                  },
                  child: const Text('Cancelar')),
              FilledButton(
                  onPressed: () {
                    context.pop(true);
                  },
                  child: const Text('Eliminar')),
            ],
          ));
}

Future<Color?> colorDialog(BuildContext context, Color currentColor) async {
  return await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Seleccionar tema'),
      content: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: HueRingPicker(
            pickerColor: currentColor,
            onColorChanged: (newColor) =>
                setState(() => currentColor = newColor),
          ),
        );
      }),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Cancelar')),
        FilledButton(
            onPressed: () {
              context.pop(currentColor);
            },
            child: const Text('Aceptar')),
      ],
    ),
  );
}

void imageDialog(BuildContext context, String imagePath, Function refreshImage,
    Function refreshImagesList) {
  final ImagePicker imgPicker = ImagePicker();

  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      final textStyle = Theme.of(context).textTheme;
      return Dialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 120.0, vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar',
                style: textStyle.titleMedium,
              ),
              TextButton.icon(
                icon: const Icon(Icons.image_search),
                label: const Text('Galería'),
                onPressed: () async {
                  XFile? xImage =
                      await imgPicker.pickImage(source: ImageSource.gallery);
                  if (xImage != null) {
                    File newImage = File(xImage.path);
                    newImage.copy(imagePath);
                    refreshImage();
                  }

                  if (context.mounted) context.pop();
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Cámara'),
                onPressed: () async {
                  XFile? xImage =
                      await imgPicker.pickImage(source: ImageSource.camera);
                  if (xImage != null) {
                    File newImage = File(xImage.path);
                    newImage.copy(imagePath);
                    refreshImage();
                  }

                  if (context.mounted) context.pop();
                },
              ),
              const Divider(),
              TextButton.icon(
                icon: const Icon(Icons.hide_image_outlined),
                label: const Text('Eliminar'),
                onPressed: () async {
                  if (await deleteImageDialog(context)) {
                    File image = File(imagePath);
                    image.delete();
                    refreshImagesList();
                  }
                  if (context.mounted) context.pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

// tree es el arbol a editar, si tree == null es porque se está creando un árbol
void treeDialog(BuildContext context, String title, Repository repository,
    Tree? tree, Function refreshFunction) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int treeId;
  String name = '';
  String scientificName = '';
  String family = '';
  int quantityBsAs = 0;

  final ImagePicker imgPicker = ImagePicker();
  List<XFile>? pickedImages;

  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        final textStyle = Theme.of(context).textTheme;
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textStyle.headlineSmall),
                Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: (tree != null) ? tree.name : '',
                              decoration: InputDecoration(
                                labelText: 'Nombre informal',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nombre vacío';
                                }
                                return null;
                              },
                              onSaved: (value) => name = value!,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              initialValue:
                                  (tree != null) ? tree.scientificName : '',
                              decoration: InputDecoration(
                                labelText: 'Nombre científico',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nombre científico vacío';
                                }
                                return null;
                              },
                              onSaved: (value) => scientificName = value!,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              initialValue: (tree != null) ? tree.family : '',
                              decoration: InputDecoration(
                                labelText: 'Familia',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Familia vacía';
                                }
                                return null;
                              },
                              onSaved: (value) => family = value!,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              initialValue: (tree != null)
                                  ? tree.quantityBsAs.toString()
                                  : '',
                              decoration: InputDecoration(
                                labelText: 'Cantidad en CABA',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  label: const Text('Agregar fotos'),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  onPressed: () async {
                    pickedImages = await imgPicker.pickMultiImage(limit: 10);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                              treeId = await repository.insertTree(
                                Tree(
                                  name: name,
                                  scientificName: scientificName,
                                  family: family,
                                  quantityBsAs: quantityBsAs,
                                ),
                              );

                              if (context.mounted) {
                                showSnackbar(
                                    context, 'Árbol agregado correctamente');
                              }
                            } else {
                              treeId = tree.id!;
                              await repository.updateTree(
                                Tree(
                                  id: tree.id,
                                  name: name,
                                  scientificName: scientificName,
                                  family: family,
                                  quantityBsAs: quantityBsAs,
                                ),
                              );
                              globalFlagRefreshList = true;
                              if (context.mounted) {
                                showSnackbar(
                                    context, 'Árbol editado correctamente');
                              }
                            }

                            if (pickedImages != null) {
                              if (pickedImages!.isNotEmpty) {
                                final Directory imagesDir = Directory(
                                    '${userDocsDirectory.path}/images/$treeId');
                                if (!imagesDir.existsSync()) {
                                  imagesDir.createSync(recursive: true);
                                }
                                for (final file in pickedImages!) {
                                  File image = File(file.path);

                                  image.copy('${imagesDir.path}/${file.name}');
                                }
                              }
                            }

                            refreshFunction();
                            if (context.mounted) context.pop();
                          }
                        },
                        child: const Text('Aceptar')),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

// user es el usuario a editar, si user == null es porque se está creando un usuario
void userDialog(BuildContext context, String title, Repository repository,
    User? user, Function? refreshUser) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  String inputName = '';
  String inputEmail = '';
  String inputPassword = '';
  int? inputAge = 0;
  Gender selectedGender;

  bool _isObscure = true;

  if (user != null) {
    selectedGender = user.gender;
  } else {
    selectedGender = Gender.Otro;
  }

  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        final textStyle = Theme.of(context).textTheme;
        return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textStyle.headlineSmall),
                  Flexible(
                    child: StatefulBuilder(
                      builder: (context, setState) => SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextFormField(
                                  initialValue: (user != null) ? user.name : '',
                                  decoration: InputDecoration(
                                    labelText: 'Nombre',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nombre vacío';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => inputName = value!,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue:
                                      (user != null) ? user.email : '',
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email vacío';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => inputEmail = value!,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue:
                                      (user != null) ? user.password : '',
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    suffixIcon: IconButton(
                                      icon: Icon(_isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () => setState(
                                          () => _isObscure = !_isObscure),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Contraseña vacía';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => inputPassword = value!,
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  initialValue:
                                      (user != null) ? user.age.toString() : '',
                                  decoration: InputDecoration(
                                    labelText: 'Edad',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                const SizedBox(height: 15),
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                                int userId = await repository.insertUser(
                                  User(
                                    name: inputName,
                                    email: inputEmail,
                                    password: inputPassword,
                                    age: inputAge,
                                    gender: selectedGender,
                                  ),
                                );

                                await asyncPrefs.setInt('activeUserId', userId);
                                if (context.mounted) {
                                  context.go('/trees/$userId');
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
                                  showSnackbar(context, 'Usuario editado');
                                  context.pop();
                                }
                                if (refreshUser != null) refreshUser();
                              }
                            }
                          },
                          child: const Text('Aceptar')),
                    ],
                  )
                ],
              ),
            ));
      });
}
