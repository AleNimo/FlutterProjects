import 'package:collection/collection.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';

import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/user.dart';

class FakeRepository implements Repository {
  //Lista de árboles
  final List<Tree> _treesList = [
    Tree(
        id: 1,
        name: 'Jacarandá',
        scientificName: 'Jacaranda mimosifolia',
        family: 'Bignoniaceae',
        quantityBsAs: 14000,
        imageURL:
            'https://1.bp.blogspot.com/-mCpNUNEPI8c/XYpAYIGigQI/AAAAAAAAn3I/4Kk3xRfR8Y8R6ahYqlZdM-qcpRkEVhncwCLcBGAsYHQ/s1600/01%2B%252815%2529.jpg'),
    Tree(
        id: 2,
        name: 'Tipa',
        scientificName: 'Tipuana tipu',
        family: 'Fabaceae, subfamilia: Papilionoideae',
        quantityBsAs: 14000,
        imageURL:
            'https://buenosaires.gob.ar/sites/default/files/media/image/2021/12/15/3b0c7398baf091560bae7fb12e9f75e58fd515d7.png'),
    Tree(
        id: 3,
        name: 'Palo Borracho',
        scientificName: 'Ceiba speciosa',
        family: 'Malvaceae',
        quantityBsAs: 5000,
        imageURL:
            'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.flores.ninja%2Fwp-content%2Fuploads%2F2018%2F04%2FPalo-borracho.jpg&f=1&nofb=1&ipt=a675746f67259c4492796d95f4baf63b78986e525e35274db43e12f9c75ddb21&ipo=images'),
    Tree(
        id: 4,
        name: 'Ceibo',
        scientificName: 'Erythrina crista-galli',
        family: 'Fabaceae, subfamilia: Faboideae',
        quantityBsAs: 1500,
        imageURL:
            'https://i.pinimg.com/originals/5c/fe/5b/5cfe5bb85d3ae242ffd8d91552be348e.jpg'),
  ];

  //Lista de usuarios
  final List<User> _usersList = [
    User(
      id: 1,
      name: 'Alejo',
      email: 'alejo@email.com',
      password: '1234',
      age: 24,
      gender: Gender.Masculino,
    ),
    User(
      id: 2,
      name: 'Joaquín',
      email: 'joaquin@email.com',
      password: '4321',
      age: 24,
      gender: Gender.Masculino,
    ),
    User(
      id: 3,
      name: 'Ana',
      email: 'ana@email.com',
      password: '1111',
      age: 62,
      gender: Gender.Femenino,
    ),
    User(
      id: 4,
      name: 'Juan',
      email: 'juan@email.com',
      password: '2134',
      age: 45,
      gender: Gender.Masculino,
    ),
    User(
      id: 5,
      name: 'Eluney',
      email: 'pelunita@gmail.com',
      password: '4488',
      age: 62,
      gender: Gender.Femenino,
    )
  ];

  List<User> getUsersNoDelay() {
    return _usersList;
  }

  @override
  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(seconds: 2));
    return _usersList;
  }

  @override
  Future<User?> getUserById(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    return _usersList.firstWhereOrNull((user) => user.id == id);
  }

  @override
  Future<void> insertUser(User user) async {
    await Future.delayed(const Duration(seconds: 1));
    if (user.id == null) {
      _usersList.add(User(
        id: _usersList.last.id! + 1,
        name: user.name,
        email: user.email,
        password: user.password,
        age: user.age,
        gender: user.gender,
      ));
    } else {
      _usersList.add(user);
    }
  }

  @override
  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(seconds: 1));
    _usersList[
        _usersList.indexWhere((userInList) => userInList.id == user.id)] = user;
  }

  @override
  Future<void> deleteUser(User user) async {
    await Future.delayed(const Duration(seconds: 1));
    _usersList.remove(user);
  }

  List<Tree> getTreesNoDelay() {
    return _treesList;
  }

  @override
  Future<List<Tree>> getTrees() async {
    await Future.delayed(const Duration(seconds: 2));
    return _treesList;
  }

  @override
  Future<Tree?> getTreeById(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    return _treesList.firstWhereOrNull((tree) => tree.id == id);
  }

  @override
  Future<void> insertTree(Tree tree) async {
    await Future.delayed(const Duration(seconds: 1));
    if (tree.id == null) {
      _treesList.add(Tree(
        id: _treesList.last.id! + 1,
        name: tree.name,
        scientificName: tree.scientificName,
        family: tree.family,
        quantityBsAs: tree.quantityBsAs,
        imageURL: tree.imageURL,
      ));
    } else {
      _treesList.add(tree);
    }
  }

  @override
  Future<void> updateTree(Tree tree) async {
    await Future.delayed(const Duration(seconds: 1));
    _treesList[
        _treesList.indexWhere((treeInList) => treeInList.id == tree.id)] = tree;
  }

  @override
  Future<void> deleteTree(Tree tree) async {
    await Future.delayed(const Duration(seconds: 1));
    _treesList.remove(tree);
  }
}
