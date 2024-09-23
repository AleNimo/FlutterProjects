import 'package:primer_parcial/domain/models/tree.dart';
import 'package:primer_parcial/domain/models/user.dart';

abstract class Repository {
  Future<List<Tree>> getTrees();
  Future<Tree?> getTreeById(int id);

  Future<List<User>> getUsers();
  Future<User?> getUserById(int id);
}
