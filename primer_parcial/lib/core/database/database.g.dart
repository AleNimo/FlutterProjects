// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TreeDao? _treeDaoInstance;

  UserDao? _userDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Tree` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `scientificName` TEXT NOT NULL, `family` TEXT NOT NULL, `quantityBsAs` INTEGER NOT NULL, `imageURL` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL, `age` INTEGER, `gender` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TreeDao get treeDao {
    return _treeDaoInstance ??= _$TreeDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }
}

class _$TreeDao extends TreeDao {
  _$TreeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _treeInsertionAdapter = InsertionAdapter(
            database,
            'Tree',
            (Tree item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'scientificName': item.scientificName,
                  'family': item.family,
                  'quantityBsAs': item.quantityBsAs,
                  'imageURL': item.imageURL
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tree> _treeInsertionAdapter;

  @override
  Future<List<Tree>> findAllTrees() async {
    return _queryAdapter.queryList('SELECT * FROM Tree',
        mapper: (Map<String, Object?> row) => Tree(
            id: row['id'] as int?,
            name: row['name'] as String,
            scientificName: row['scientificName'] as String,
            family: row['family'] as String,
            quantityBsAs: row['quantityBsAs'] as int,
            imageURL: row['imageURL'] as String?));
  }

  @override
  Future<Tree?> findTreeById(int id) async {
    return _queryAdapter.query('SELECT * FROM Tree WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Tree(
            id: row['id'] as int?,
            name: row['name'] as String,
            scientificName: row['scientificName'] as String,
            family: row['family'] as String,
            quantityBsAs: row['quantityBsAs'] as int,
            imageURL: row['imageURL'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> insertTree(Tree tree) async {
    await _treeInsertionAdapter.insert(tree, OnConflictStrategy.abort);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'password': item.password,
                  'age': item.age,
                  'gender': item.gender
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  @override
  Future<List<User>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            age: row['age'] as int?,
            gender: row['gender'] as String?));
  }

  @override
  Future<User?> findUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM User WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            age: row['age'] as int?,
            gender: row['gender'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }
}
