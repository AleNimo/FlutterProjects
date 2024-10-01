import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/dialogs.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';
import 'package:primer_parcial/main.dart';

class TreeDetailScreen extends StatefulWidget {
  const TreeDetailScreen(
      {super.key, required this.treeId, required this.repository});

  final int treeId;

  final Repository repository;

  @override
  State<TreeDetailScreen> createState() => _TreeDetailScreenState();
}

class _TreeDetailScreenState extends State<TreeDetailScreen> {
  late Future<Tree?> treeRequest;

  @override
  void initState() {
    super.initState();
    treeRequest = widget.repository.getTreeById(widget.treeId);
  }

  void refreshTree() {
    setState(() {
      treeRequest = widget.repository.getTreeById(widget.treeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: treeRequest,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: const Color.fromARGB(255, 252, 248, 255),
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Detalle'),
              ),
              body: _TreeDetailView(
                  repository: widget.repository, tree: snapshot.data!),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  treeDialog(context, "Editar árbol", widget.repository,
                      snapshot.data!, refreshTree);
                },
                child: const Icon(Icons.edit),
              ));
        } else {
          return Text(snapshot.error.toString());
        }
      },
    );
  }
}

//Podría pasar solo el id o el objeto de la película
//Pasar el id hace que haya una doble búsqueda en la lista, pero si el item cambia no me queda el objeto desactualizado
//También se pasa el id si la información es sensible
class _TreeDetailView extends StatelessWidget {
  const _TreeDetailView({required this.repository, required this.tree});

  final Repository repository;
  final Tree tree;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Slides(tree: tree),
            const SizedBox(height: 60),
            Text(
              tree.name,
              style: textStyle
                  .headlineLarge, //Se usa el estilo de materialApp para mantener el paradigma
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Text(
              tree.scientificName,
              style: textStyle.titleMedium,
            ),
            Text(
              'Familia: ${tree.family}',
              style: textStyle.titleMedium,
            ),
            Text('Cantidad estimada en CABA: ${tree.quantityBsAs.toString()}',
                style: textStyle.titleMedium),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: TextButton.icon(
            onPressed: () {
              deleteTreeDialog(context, repository, tree);
            },
            icon: const Icon(Icons.delete),
            label: const Text('Eliminar'),
          ),
        ),
      ]),
    );
  }
}

class Slides extends StatefulWidget {
  const Slides({
    super.key,
    required this.tree,
  });

  final Tree tree;

  @override
  State<Slides> createState() => _SlidesState();
}

class _SlidesState extends State<Slides> {
  late Future<List<File>> imageFiles;

  @override
  void initState() {
    super.initState();

    imageFiles = readImages();
  }

  Future<List<File>> readImages() async {
    final Directory imagesDir =
        Directory('${userDocsDirectory.path}/images/${widget.tree.id}');

    if (imagesDir.existsSync()) {
      final List<FileSystemEntity> entities = await imagesDir.list().toList();

      return entities.whereType<File>().toList();
    } else {
      imagesDir.createSync(recursive: true);
      return List.empty();
    }
  }

  void refreshImage() {
    setState(() {});
  }

  void refreshImagesList() {
    setState(() {
      imageFiles = readImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(const Size.fromHeight(300)),
      child: FutureBuilder(
        future: imageFiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                  child: FaIcon(FontAwesomeIcons.tree, size: 100));
            } else {
              return PageView(
                children: snapshot.data!.map((imageFile) {
                  return GestureDetector(
                    onLongPress: () {
                      imageDialog(context, imageFile.path, refreshImage,
                          refreshImagesList);
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          imageFile.readAsBytesSync(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child:
                                    FaIcon(FontAwesomeIcons.tree, size: 100));
                          },
                        )),
                  );
                }).toList(),
              );
            }
          } else {
            //sin datos
            return const Center(
                child: FaIcon(FontAwesomeIcons.tree, size: 100));
          }
        },
      ),
    );
  }
}
