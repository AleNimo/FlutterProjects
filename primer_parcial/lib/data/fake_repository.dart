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
    ),
    Tree(
      id: 2,
      name: 'Tipa',
      scientificName: 'Tipuana tipu',
      family: 'Fabaceae, subfamilia: Papilionoideae',
      quantityBsAs: 14000,
    ),
    Tree(
      id: 3,
      name: 'Palo Borracho',
      scientificName: 'Ceiba speciosa',
      family: 'Malvaceae',
      quantityBsAs: 5000,
    ),
    Tree(
      id: 4,
      name: 'Ceibo',
      scientificName: 'Erythrina crista-galli',
      family: 'Fabaceae, subfamilia: Faboideae',
      quantityBsAs: 1500,
    ),
  ];

  //Lista de usuarios
  final List<User> _usersList = [
    User(
      id: 1,
      name: 'Alejo',
      email: 'alejo@email.com',
      password: '1234',
      age: 24,
      gender: Gender.male,
    ),
    User(
      id: 2,
      name: 'Joaquín',
      email: 'joaquin@email.com',
      password: '4321',
      age: 24,
      gender: Gender.male,
    ),
    User(
      id: 3,
      name: 'Ana',
      email: 'ana@email.com',
      password: '1111',
      age: 62,
      gender: Gender.female,
    ),
    User(
      id: 4,
      name: 'Juan',
      email: 'juan@email.com',
      password: '2134',
      age: 45,
      gender: Gender.male,
    ),
    User(
      id: 5,
      name: 'Eluney',
      email: 'pelunita@gmail.com',
      password: '4488',
      age: 62,
      gender: Gender.female,
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
  Future<User?> getUserByName(String name) async {
    await Future.delayed(const Duration(seconds: 1));
    return _usersList.firstWhereOrNull((user) => user.name == name);
  }

  @override
  Future<int> insertUser(User user) async {
    await Future.delayed(const Duration(seconds: 1));
    int id;
    if (user.id == null) {
      if (_usersList.isEmpty) {
        id = 1;
      } else {
        id = _usersList.last.id! + 1;
      }
      _usersList.add(user.copyWith(id: id));
    } else {
      id = user.id!;
      _usersList.add(user);
    }
    return id;
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
  Future<int> insertTree(Tree tree) async {
    await Future.delayed(const Duration(seconds: 1));
    int id;
    if (tree.id == null) {
      if (_treesList.isEmpty) {
        id = 1;
      } else {
        id = _treesList.last.id! + 1;
      }
      _treesList.add(tree.copyWith(id: id));
    } else {
      id = tree.id!;
      _treesList.add(tree);
    }
    return id;
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
