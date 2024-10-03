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

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool globalFlagRefreshList = false;

void deleteTreeDialog(BuildContext context, Repository repository, Tree tree) {
  final appLocalizations = AppLocalizations.of(context)!;
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(appLocalizations.sureDeleteTree),
            content: Text(appLocalizations.permanentAction),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(appLocalizations.cancel)),
              FilledButton(
                  onPressed: () async {
                    await repository.deleteTree(tree);

                    final Directory imagesDir = Directory(
                        '${userDocsDirectory.path}/images/${tree.id}');

                    imagesDir.deleteSync(recursive: true);

                    globalFlagRefreshList = true;
                    if (context.mounted) {
                      showSnackbar(context, appLocalizations.treeDeleted);
                      context
                        ..pop()
                        ..pop();
                    }
                  },
                  child: Text(appLocalizations.delete)),
            ],
          ));
}

void deleteUserDialog(BuildContext context, Repository repository, User user) {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  final appLocalizations = AppLocalizations.of(context)!;
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(appLocalizations.sureDeleteUser),
            content: Text(appLocalizations.permanentAction),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(appLocalizations.cancel)),
              FilledButton(
                  onPressed: () async {
                    await repository.deleteUser(user);

                    if (context.mounted) {
                      await asyncPrefs.remove('activeUserId');
                      if (context.mounted) context.go('/login');
                    }
                  },
                  child: Text(appLocalizations.delete)),
            ],
          ));
}

Future<bool> deleteImageDialog(BuildContext context) async {
  final appLocalizations = AppLocalizations.of(context)!;
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(appLocalizations.sureDeleteImage),
            content: Text(appLocalizations.permanentAction),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop(false);
                  },
                  child: Text(appLocalizations.cancel)),
              FilledButton(
                  onPressed: () {
                    showSnackbar(context, appLocalizations.imageDeleted);
                    context.pop(true);
                  },
                  child: Text(appLocalizations.delete)),
            ],
          ));
}

Future<Color?> colorDialog(BuildContext context, Color currentColor) async {
  final appLocalizations = AppLocalizations.of(context)!;
  return await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(appLocalizations.selectTheme),
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
            child: Text(appLocalizations.cancel)),
        FilledButton(
            onPressed: () {
              context.pop(currentColor);
            },
            child: Text(appLocalizations.accept)),
      ],
    ),
  );
}

void imageDialog(BuildContext context, String imagePath, Function refreshImage,
    Function refreshImagesList) {
  final ImagePicker imgPicker = ImagePicker();
  final appLocalizations = AppLocalizations.of(context)!;

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
                appLocalizations.edit,
                style: textStyle.titleMedium,
              ),
              TextButton.icon(
                icon: const Icon(Icons.image_search),
                label: Text(appLocalizations.gallery),
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
                label: Text(appLocalizations.camera),
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
                label: Text(appLocalizations.delete),
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
        final appLocalizations = AppLocalizations.of(context)!;
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
                                labelText: appLocalizations.commonName,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return appLocalizations.enterName;
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
                                labelText: appLocalizations.scientificName,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return appLocalizations.enterScientificName;
                                }
                                return null;
                              },
                              onSaved: (value) => scientificName = value!,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              initialValue: (tree != null) ? tree.family : '',
                              decoration: InputDecoration(
                                labelText: appLocalizations.family,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return appLocalizations.enterFamily;
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
                                labelText: appLocalizations.quantityCABA,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return appLocalizations.enterQuantity;
                                } else if (int.tryParse(value) == null) {
                                  return appLocalizations.mustBeNumber;
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
                  label: Text(appLocalizations.addImages),
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
                        child: Text(appLocalizations.cancel)),
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
                                    context, appLocalizations.treeAdded);
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
                                    context, appLocalizations.treeEdited);
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
                        child: Text(appLocalizations.accept)),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

// user es el usuario a editar, si user == null es porque se está creando un usuario
void userDialog({
  required BuildContext context,
  required Repository repository,
  User? userToEdit,
  Function? refreshFunction,
}) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  final appLocalizations = AppLocalizations.of(context)!;

  String title;
  String inputName = '';
  String inputEmail = '';
  String inputPassword = '';
  int? inputAge = 0;
  Gender selectedGender;

  bool _isObscure = true;

  if (userToEdit != null) {
    selectedGender = userToEdit.gender;
    title = appLocalizations.editUser;
  } else {
    selectedGender = Gender.other;
    title = appLocalizations.register;
  }

  bool isUserTaken = false;
  String lastUserValidated = '';

  Future<void> checkForm() async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();

      if (userToEdit == null) {
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
            id: userToEdit.id,
            name: inputName,
            email: inputEmail,
            password: inputPassword,
            age: inputAge,
            gender: selectedGender,
          ),
        );
        globalFlagRefreshList = true;
        if (context.mounted) {
          showSnackbar(context, appLocalizations.userEdited);
          context.pop();
        }
        if (refreshFunction != null) refreshFunction();
      }
    }
  }

  Future<void> initAsyncNameValidation(String name) async {
    if (await repository.getUserByName(name) == null) {
      isUserTaken = false;
    } else {
      isUserTaken = true;
    }
    lastUserValidated = name;

    checkForm();
  }

  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        final textStyle = Theme.of(context).textTheme;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Dialog(
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
                                    initialValue: (userToEdit != null)
                                        ? userToEdit.name
                                        : '',
                                    decoration: InputDecoration(
                                      labelText: appLocalizations.name,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return appLocalizations.enterName;
                                      }
                                      if (value == lastUserValidated) {
                                        if (isUserTaken) {
                                          return 'User already exists';
                                        }
                                      } else {
                                        initAsyncNameValidation(value);
                                        return 'Validating';
                                      }

                                      return null;
                                    },
                                    onSaved: (value) => inputName = value!,
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    initialValue: (userToEdit != null)
                                        ? userToEdit.email
                                        : '',
                                    decoration: InputDecoration(
                                      labelText: appLocalizations.email,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return appLocalizations.enterEmail;
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => inputEmail = value!,
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    initialValue: (userToEdit != null)
                                        ? userToEdit.password
                                        : '',
                                    obscureText: _isObscure,
                                    decoration: InputDecoration(
                                      labelText: appLocalizations.password,
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
                                        return appLocalizations.enterPassword;
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => inputPassword = value!,
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    initialValue: (userToEdit != null)
                                        ? userToEdit.age.toString()
                                        : '',
                                    decoration: InputDecoration(
                                      labelText: appLocalizations.age,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return appLocalizations.enterAge;
                                      } else {
                                        if (int.tryParse(value) == null) {
                                          return appLocalizations.mustBeNumber;
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
                                    title: Text(appLocalizations.gender),
                                    subtitle: switch (selectedGender) {
                                      Gender.male =>
                                        Text(appLocalizations.male),
                                      Gender.female =>
                                        Text(appLocalizations.female),
                                      Gender.other =>
                                        Text(appLocalizations.other),
                                    },
                                    children: [
                                      RadioListTile(
                                        value: Gender.male,
                                        groupValue: selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedGender = value as Gender;
                                          });
                                        },
                                        title: Text(appLocalizations.male),
                                      ),
                                      RadioListTile(
                                        value: Gender.female,
                                        groupValue: selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedGender = value as Gender;
                                          });
                                        },
                                        title: Text(appLocalizations.female),
                                      ),
                                      RadioListTile(
                                        value: Gender.other,
                                        groupValue: selectedGender,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedGender = value as Gender;
                                          });
                                        },
                                        title: Text(appLocalizations.other),
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
                            child: Text(appLocalizations.cancel)),
                        FilledButton(
                            onPressed: checkForm,
                            child: Text(appLocalizations.accept)),
                      ],
                    )
                  ],
                ),
              )),
        );
      });
}
