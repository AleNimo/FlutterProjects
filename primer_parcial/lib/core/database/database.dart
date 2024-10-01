// required package imports
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:floor/floor.dart';
import 'package:primer_parcial/core/database/type_converter.dart';
import 'package:primer_parcial/data/fake_repository.dart';
import 'package:primer_parcial/domain/models/user.dart';
import 'package:primer_parcial/main.dart';
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
        await _saveAssetsInDevice();
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
          'gender': item.gender.index,
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
        },
      ).insert(tree, OnConflictStrategy.replace);
    }
  }

  static _saveAssetsInDevice() async {
    final String imagesPath = '${userDocsDirectory.path}/images';

    final Directory imagesDir = Directory(imagesPath);
    if (!imagesDir.existsSync()) {
      imagesDir.createSync(recursive: true);
    }

    final AssetManifest assetManifest =
        await AssetManifest.loadFromAssetBundle(rootBundle);
    final List<String> assets = assetManifest.listAssets();

    for (String asset in assets) {
      List<String> assetSplit = asset.split('/');
      if (assetSplit.length > 1) {
        int? assetGroupNumber = int.tryParse(assetSplit[1]);
        if (assetGroupNumber != null) {
          // Creo el subdirectorio si para cada item si no existe
          final Directory groupDir = Directory('$imagesPath/$assetGroupNumber');
          if (!groupDir.existsSync()) {
            groupDir.createSync(recursive: true);
          }

          // Cargo el asset como bytes para después grabarlos (no puedo abrirlo como archivo normal)
          final ByteData data = await rootBundle.load(asset);
          final List<int> bytes = data.buffer.asUint8List();

          // Write the asset to the device
          final File file = File('${groupDir.path}/${assetSplit[2]}');
          await file.writeAsBytes(bytes);
        }
      }
    }
  }
}
