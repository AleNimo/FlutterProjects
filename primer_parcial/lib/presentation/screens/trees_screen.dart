import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/user.dart';

import 'package:primer_parcial/domain/models/dialogs.dart';

import 'package:primer_parcial/domain/repositories/repository.dart';

class TreesScreen extends StatefulWidget {
  const TreesScreen(
      {super.key, required this.userId, required this.repository});

  final int userId;

  final Repository repository;

  @override
  State<TreesScreen> createState() => _TreesScreenState();
}

class _TreesScreenState extends State<TreesScreen> {
  late Future<List<Tree>> treesRequest;
  late Future<User?> userRequest;

  @override
  void initState() {
    super.initState();
    treesRequest = widget.repository.getTrees();
    userRequest = widget.repository.getUserById(widget.userId);
  }

  void refreshList() {
    setState(() {
      treesRequest = widget.repository.getTrees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([userRequest, treesRequest]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: const Color.fromARGB(255, 252, 248, 255),
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          User user = snapshot.data![0]! as User;
          List<Tree> trees = snapshot.data![1] as List<Tree>;

          String welcomeText = '';

          if (user.gender == 'M') {
            welcomeText = 'Bienvenido, ${user.name}';
          } else if (user.gender == 'F') {
            welcomeText = 'Bienvenida, ${user.name}';
          } else {
            welcomeText = 'Bienvenid@, ${user.name}';
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(welcomeText),
            ),
            body: (trees.isEmpty)
                ? const Center(child: Text('Sin árboles para mostrar'))
                : _TreesView(
                    treeList: trees,
                    onRefresh: () async => refreshList(),
                  ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  treeDialog(
                      context, 'Ingresar nuevo árbol', null, refreshList);
                },
                child: const Icon(Icons.add)),
          );
        } else {
          return Center(child: Text(snapshot.error.toString()));
        }
      },
    );
  }
}

class _TreesView extends StatelessWidget {
  const _TreesView(
      {super.key, required this.treeList, required this.onRefresh});

  final List<Tree> treeList;

  final Function onRefresh;

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
          child: RefreshIndicator(
            onRefresh: () async => onRefresh(),
            child: ListView.builder(
              //ListViewBuilder sirve para listas dinamicas, ya tiene función de scroll, etc
              itemCount: treeList.length,
              itemBuilder: (context, index) {
                //Vendría a ser una especie de forEach que recorre todos los elementos con index y retorna un widget para cada item
                return _TreeItem(
                  tree: treeList[index],
                  onRefresh: () async => onRefresh(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _TreeItem extends StatelessWidget {
  const _TreeItem({required this.tree, required this.onRefresh});

  final Tree tree;

  final Function onRefresh;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //Widget que permite agregar gestos a widgets que no lo tienen (en este caso no es necesario)
      onTap: () async {
        await context.push('/treeDetail/${tree.id}');
        if (globalFlagRefreshList == true) {
          globalFlagRefreshList = false;
          onRefresh();
        }
      },
      child: Card(
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              tree.imageURL!,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return const FaIcon(FontAwesomeIcons.tree, size: 50);
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
