import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:primer_parcial/core/router/app_router.dart';
import 'package:primer_parcial/domain/models/snackbar.dart';
import 'package:primer_parcial/domain/models/tree.dart';

bool globalFlagRefreshList = false;

void deleteDialog(BuildContext context, Tree tree) {
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
void treeDialog(
    BuildContext context, String title, Tree? tree, Function refreshFunction) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = '';
  String scientificName = '';
  String family = '';
  int quantityBsAs = 0;
  String? imageURL;

  showDialog(
      barrierDismissible: false,
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
