import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tp2_log_in/domain/tree.dart';
import 'package:tp2_log_in/data/trees_repository.dart';

class TreesScreen extends StatelessWidget {
  const TreesScreen({super.key, required this.userName});

  final String userName;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido/a, $userName'),
      ),
      body: _TreesView(trees: treeList),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSnackbar(context, 'Árbol agregado');
          },
          child: const Icon(Icons.add)),
    );
  }
}

class _TreesView extends StatelessWidget {
  const _TreesView({required this.trees});

  final List<Tree> trees;
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Árboles de la Ciudad de Buenos Aires:',
                  style: textStyle.titleLarge),
            )),
        Expanded(
          child: ListView.builder(
            //ListViewBuilder sirve para listas dinamicas, ya tiene función de scroll, etc
            itemCount: trees.length,
            itemBuilder: (context, index) {
              //Vendría a ser una especie de forEach que recorre todos los elementos con index y retorna un widget para cada item
              return _TreeItem(tree: trees[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _TreeItem extends StatelessWidget {
  const _TreeItem({
    required this.tree,
  });

  final Tree tree;

  // Future<Image> _load_image() async{
  //   Image.network(tree.imageURL!);
  // } = Future<Image>.delayed(const Duration(seconds: 2), () => Image.network(tree.imageURL!),);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //Widget que permite agregar gestos a widgets que no lo tienen
      onTap: () {
        context.push('/treeDetail/${tree.id}');
      },
      child: Card(
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              tree.imageURL!,
              errorBuilder: (context, error, stackTrace) {
                return const FaIcon(FontAwesomeIcons.tree);
              },
            ),
          ),
          title: Text(tree.name),
          subtitle: Text(tree.scientificName),
          trailing: const Icon(Icons.arrow_forward),
          // onTap: () {
          //   context.push('/treeDetail/${tree.id}');
          // },
        ),
      ),
    );
  }
}
