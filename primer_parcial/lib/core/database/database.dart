// required package imports
import 'dart:async';
import 'dart:developer';
import 'package:floor/floor.dart';
import 'package:primer_parcial/data/fake_repository.dart';
import 'package:primer_parcial/domain/models/user.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:primer_parcial/data/user_dao.dart';
import 'package:primer_parcial/data/tree_dao.dart';
import 'package:primer_parcial/domain/models/tree.dart';
part 'database.g.dart'; // el código generado va a estar en el .g.dart

@Database(version: 1, entities: [Tree, User])
abstract class AppDatabase extends FloorDatabase {
  TreeDao get treeDao;
  UserDao get userDao;

  static Future<AppDatabase> create(String name) {
    return $FloorAppDatabase.databaseBuilder(name).addCallback(Callback(
      onCreate: (database, version) async {
        await _prepopulate(database);
      },
    )).build();
  }

  static Future<void> _prepopulate(sqflite.DatabaseExecutor database) async {
    log('Primera vez: lleno base de datos');

    final users = FakeRepository().getUsersNoDelay();
    final trees = FakeRepository().getTreesNoDelay();

    for (final user in users) {
      // Inserto cada usuario en la base de datos.
      await InsertionAdapter(
        database,
        'User',
        (User item) => <String, Object?>{
          'id': item.id,
          'name': item.name,
          'email': item.email,
          'password': item.password,
          'age': item.age,
          'gender': item.gender,
        },
      ).insert(user, OnConflictStrategy.replace);
    }

    for (final tree in trees) {
      // Inserto cada árbol en la base de datos.
      await InsertionAdapter(
        database,
        'Tree',
        (Tree item) => <String, Object?>{
          'id': item.id,
          'name': item.name,
          'scientificName': item.scientificName,
          'family': item.family,
          'quantityBsAs': item.quantityBsAs,
          'imageURL': item.imageURL,
        },
      ).insert(tree, OnConflictStrategy.replace);
    }
  }
}
