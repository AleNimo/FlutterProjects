import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String email;
  final String password; //con _password podría ser atributo privado

  final int?
      age; //el ? significa que no hace falta que esté inicializado (puede ser null)

  final String? gender;

  // Init con constructor con pasaje de parámetros
  // User(id, name, email, password, age) :
  //   this.id = id,
  //   this.name = name,
  //   this.email = email,
  //   this._password = password,
  //   this.age = age;

  //Forma que permite dart, que no te obliga a pasar los parámetros en orden
  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.age,
    this.gender = 'X',
  });
}
