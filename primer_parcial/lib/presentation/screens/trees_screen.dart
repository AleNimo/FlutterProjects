import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:primer_parcial/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primer_parcial/domain/models/menu_items.dart';

import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/user.dart';
import 'package:primer_parcial/domain/models/dialogs.dart';

import 'package:primer_parcial/domain/repositories/repository.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  final scaffoldKey = GlobalKey<ScaffoldState>();

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

  void refreshUser() {
    setState(() {
      userRequest = widget.repository.getUserById(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: Future.wait([userRequest, treesRequest]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          User user = snapshot.data![0]! as User;
          List<Tree> trees = snapshot.data![1] as List<Tree>;

          String endingChar = '';

          if (appLocalizations.localeName == 'es') {
            switch (user.gender) {
              case Gender.male:
                endingChar = 'o';
                break;
              case Gender.female:
                endingChar = 'a';
                break;
              default:
                endingChar = '@';
            }
          }

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title:
                  Text('${appLocalizations.welcome}$endingChar, ${user.name}'),
            ),
            body: (trees.isEmpty)
                ? Center(child: Text(appLocalizations.noTrees))
                : _TreesView(
                    treeList: trees,
                    onRefresh: () async => refreshList(),
                  ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  treeDialog(context, appLocalizations.newTree,
                      widget.repository, null, refreshList);
                },
                child: const Icon(Icons.add)),
            drawer: MenuDrawer(
              scaffoldKey: scaffoldKey,
              userId: user.id!,
              refreshUser: refreshUser,
            ),
          );
        } else {
          return Center(child: Text(snapshot.error.toString()));
        }
      },
    );
  }
}

class MenuDrawer extends StatefulWidget {
  MenuDrawer({
    super.key,
    required this.scaffoldKey,
    required this.userId,
    required this.refreshUser,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final int userId;
  final Function refreshUser;

  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    List<MenuItem> menuItems = [
      MenuItem(
        title: appLocalizations.userProfile,
        icon: Icons.person,
        link: '/userProfile',
      ),
      MenuItem(
        title: appLocalizations.settings,
        icon: Icons.settings,
        link: '/configuration',
      ),
      MenuItem(
        title: appLocalizations.logout,
        icon: Icons.logout,
        link: '/login', //(vuelve a pantalla de login)
      ),
    ];
    return NavigationDrawer(
      selectedIndex: null,
      onDestinationSelected: (value) async {
        switch (value) {
          case 0:
            await context.push('${menuItems[value].link}/${widget.userId}');
            if (globalFlagRefreshList) {
              globalFlagRefreshList = false;
              widget.refreshUser();
            }
            break;
          case 1:
            context.push(menuItems[value].link);
            break;
          case 2:
            await widget.asyncPrefs.remove('activeUserId');
            if (context.mounted) context.go(menuItems[value].link);
          default:
        }
        widget.scaffoldKey.currentState?.closeDrawer();
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 28, 5),
          child: Text(appLocalizations.menu,
              style: Theme.of(context).textTheme.titleLarge),
        ),
        ...menuItems.map((item) => NavigationDrawerDestination(
              icon: Icon(item.icon),
              label: Text(item.title),
            ))
      ],
    );
  }
}

class _TreesView extends StatelessWidget {
  const _TreesView({required this.treeList, required this.onRefresh});

  final List<Tree> treeList;

  final Function onRefresh;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final textStyle = Theme.of(context).textTheme;
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(appLocalizations.treesCABA, style: textStyle.titleLarge),
            )),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => onRefresh(),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: GridView.builder(
                //ListViewBuilder sirve para listas dinámicas, ya tiene función de scroll, etc
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
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
        ),
      ],
    );
  }
}

class _TreeItem extends StatefulWidget {
  const _TreeItem({required this.tree, required this.onRefresh});

  final Tree tree;

  final Function onRefresh;

  @override
  State<_TreeItem> createState() => _TreeItemState();
}

class _TreeItemState extends State<_TreeItem> {
  late final Future<File?> image;

  @override
  void initState() {
    super.initState();
    image = getImage();
  }

  Future<File?> getImage() async {
    final Directory imagesDir =
        Directory('${userDocsDirectory.path}/images/trees/${widget.tree.id}');

    if (imagesDir.existsSync()) {
      final List<FileSystemEntity> entities = await imagesDir.list().toList();

      var images = entities.whereType<File>();

      if (images.isNotEmpty) {
        return images.first;
      } else {
        return null;
      }
    } else {
      imagesDir.createSync(recursive: true);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return GestureDetector(
      //Widget que permite agregar gestos a widgets que no lo tienen (en este caso no era necesario)
      onTap: () async {
        await context.push('/treeDetail/${widget.tree.id}');
        if (globalFlagRefreshList == true) {
          globalFlagRefreshList = false;
          widget.onRefresh();
        }
      },
      child: Card.filled(
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 5,
        child: GridTile(
          header: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Center(
                child: Text(widget.tree.name, style: textStyle.headlineSmall)),
          ),
          footer: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              widget.tree.scientificName,
              style: textStyle.titleSmall,
            )),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FutureBuilder(
                  future: image,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      return Image.memory(
                        fit: BoxFit.cover,
                        snapshot.data!.readAsBytesSync(),
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                  child:
                                      FaIcon(FontAwesomeIcons.tree, size: 20)));
                        },
                      );
                    } else {
                      //Sin datos
                      return const SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                              child: FaIcon(FontAwesomeIcons.tree, size: 20)));
                    }
                  },
                )),
          ),
        ),
      ),
    );
  }
}
