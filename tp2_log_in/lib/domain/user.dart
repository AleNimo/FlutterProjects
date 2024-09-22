class User {
  String id;
  String name;
  String email;
  String password = '0000'; //con _password podría ser atributo privado

  int?
      age; //el ? significa que no hace falta que esté inicializado (puede ser null)

  // Init con constructor con pasaje de parámetros
  // User(id, name, email, password, age) :
  //   this.id = id,
  //   this.name = name,
  //   this.email = email,
  //   this._password = password,
  //   this.age = age;

  //Forma que permite dart, que no te obliga a pasar los parámetros en orden
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.age,
  });
}
