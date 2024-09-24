import 'package:primer_parcial/data/tree_dao.dart';
import 'package:primer_parcial/data/user_dao.dart';
import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/user.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';
import 'package:primer_parcial/main.dart';

class LocalRepository implements Repository {
  final UserDao _userDao = database.userDao;
  final TreeDao _treeDao = database.treeDao;

  @override
  Future<List<User>> getUsers() {
    return _userDao.findAllUsers();
  }

  @override
  Future<User?> getUserById(int id) {
    return _userDao.findUserById(id);
  }

  @override
  Future<void> insertUser(User user) {
    return _userDao.insertUser(user);
  }

  @override
  Future<void> updateUser(User user) {
    return _userDao.updateUser(user);
  }

  @override
  Future<void> deleteUser(User user) {
    return _userDao.deleteUser(user);
  }

  @override
  Future<List<Tree>> getTrees() {
    return _treeDao.findAllTrees();
  }

  @override
  Future<Tree?> getTreeById(int id) {
    return _treeDao.findTreeById(id);
  }

  @override
  Future<void> insertTree(Tree tree) {
    return _treeDao.insertTree(tree);
  }

  @override
  Future<void> updateTree(Tree tree) {
    return _treeDao.updateTree(tree);
  }

  @override
  Future<void> deleteTree(Tree tree) {
    return _treeDao.deleteTree(tree);
  }
}
