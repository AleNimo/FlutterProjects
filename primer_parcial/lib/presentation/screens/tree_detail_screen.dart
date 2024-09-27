import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/dialogs.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';

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
                title: const Text('Tree Detail'),
              ),
              body: _TreeDetailView(
                repository: widget.repository,
                tree: (snapshot.data != null)
                    ? snapshot.data!
                    : Tree(
                        id: widget.treeId,
                        name: 'Not Found',
                        scientificName: 'Not Found',
                        family: 'Not Found',
                        quantityBsAs: 0,
                      ),
              ),
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (tree.imageURL != null)
                  ? Image.network(
                      tree.imageURL!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const FaIcon(FontAwesomeIcons.tree, size: 50),
                    )
                  : const FaIcon(FontAwesomeIcons.tree, size: 100),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tree.name,
                  style: textStyle
                      .titleLarge, //Se usa el estilo de materialApp para mantener el paradigma
                  textAlign: TextAlign.left,
                ),
                Text(
                  tree.scientificName,
                  style: textStyle.bodyMedium,
                ),
                Text(
                  'Familia: ${tree.family}',
                  style: textStyle.bodyMedium,
                ),
                Text(
                    'Cantidad de árboles en CABA: ${tree.quantityBsAs.toString()}',
                    style: textStyle.bodyMedium),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: () {
              deleteDialog(context, repository, tree);
            },
            icon: const Icon(Icons.delete),
            label: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
