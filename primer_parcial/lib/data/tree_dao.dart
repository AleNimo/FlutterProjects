import 'package:floor/floor.dart';
import 'package:primer_parcial/domain/models/tree.dart';

//Las clases abstractas no se pueden instanciar, son plantillas de clases
//En otro lugar va a haber una clase que implemente los métodos de esta clase abstracta
//En este caso Floor es el que genera una clase que implementa esta clase abstracta.
@dao
abstract class TreeDao {
  @Query('SELECT * FROM Tree')
  Future<List<Tree>> findAllTrees();

  @Query('SELECT * FROM Tree WHERE id = :id')
  Future<Tree?> findTreeById(int id);

  @insert
  Future<void> insertTree(Tree tree);

  @update
  Future<void> updateTree(Tree tree);

  // @delete
  // Future<void> deleteTree(Tree tree);
}
