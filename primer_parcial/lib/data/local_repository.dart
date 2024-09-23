import 'package:primer_parcial/data/tree_dao.dart';
import 'package:primer_parcial/data/user_dao.dart';
import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/user.dart';
import 'package:primer_parcial/domain/repositories/repository.dart';
import 'package:primer_parcial/main.dart';

class LocalRepository implements Repository {
  final TreeDao _treeDao = database.treeDao;
  final UserDao _userDao = database.userDao;
  @override
  Future<List<Tree>> getTrees() {
    return _treeDao.findAllTrees();
  }

  @override
  Future<Tree?> getTreeById(int id) {
    return _treeDao.findTreeById(id);
  }

  @override
  Future<List<User>> getUsers() {
    return _userDao.findAllUsers();
  }

  @override
  Future<User?> getUserById(int id) {
    return _userDao.findUserById(id);
  }
}
