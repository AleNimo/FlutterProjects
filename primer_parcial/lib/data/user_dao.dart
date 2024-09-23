import 'package:floor/floor.dart';
import 'package:primer_parcial/domain/models/user.dart';

//Las clases abstractas no se pueden instanciar, son plantillas de clases
//En otro lugar va a haber una clase que implemente los métodos de esta clase abstracta
//En este caso Floor es el que genera una clase que implementa esta clase abstracta.
@dao
abstract class UserDao {
  @Query('SELECT * FROM User')
  Future<List<User>> findAllUsers();

  @Query('SELECT * FROM User WHERE id = :id')
  Future<User?> findUserById(int id);

  @insert
  Future<void> insertUser(User user);
}
