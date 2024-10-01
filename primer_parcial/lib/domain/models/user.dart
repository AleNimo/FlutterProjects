import 'package:floor/floor.dart';
import 'package:primer_parcial/core/database/type_converter.dart';

enum Gender { Masculino, Femenino, Otro }

@entity
@TypeConverters([GenderConverter])
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String email;
  final String password; //con _password podría ser atributo privado
  final int?
      age; //el ? significa que no hace falta que esté inicializado (puede ser null)

  final Gender gender;

  // bool _isActive = false; //Para saber si hay una sesión activa (solo un usuario puede estar activo)
  //Quizás una mejor forma para agilizar la búsqueda sería hacer que haya otra tabla que contenga al usuario activo (o esté vacía)
  //Y si se puede limitar la cantidad elementos a 1 sería ideal para que no haya conflicto de sesión activa.

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
    this.gender = Gender.Otro,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    int? age,
    Gender? gender,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }
}
