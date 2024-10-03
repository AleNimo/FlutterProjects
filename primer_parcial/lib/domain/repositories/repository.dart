import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/user.dart';

abstract class Repository {
  Future<List<Tree>> getTrees();
  Future<Tree?> getTreeById(int id);
  Future<int> insertTree(Tree tree);
  Future<void> updateTree(Tree tree);
  Future<void> deleteTree(Tree tree);

  Future<List<User>> getUsers();
  Future<User?> getUserById(int id);
  Future<User?> getUserByName(String name);
  Future<int> insertUser(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(User user);
}
