import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';

void confirmationDialog(BuildContext context, String text) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(text),
            content: const Text('Esta acción no puede ser deshecha.'),
            actions: [
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('CANCEL')),
              FilledButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('OK')),
            ],
          ));
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree Detail'),
      ),
      body: FutureBuilder(
        future: treeRequest,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return _TreeDetailView(
              tree: (snapshot.data != null)
                  ? snapshot.data!
                  : Tree(
                      id: widget.treeId,
                      name: 'Not Found',
                      scientificName: 'Not Found',
                      family: 'Not Found',
                      quantityBsAs: 0,
                    ),
            );
          } else {
            return Text(snapshot.error.toString());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          confirmationDialog(context, "Editar árbol");
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

//Podría pasar solo el id o el objeto de la pelicula
//Pasar el id hace que haya una doble busqueda en la lista, pero si la peli cambia no me queda el objeto desactualizado
//Tambien se pasa el id si la información es sensible
class _TreeDetailView extends StatelessWidget {
  const _TreeDetailView({
    required this.tree,
  });

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
              confirmationDialog(
                  context, '¿Seguro que desea eliminar el árbol?');
            },
            icon: const Icon(Icons.delete),
            label: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
